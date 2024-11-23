from flask import Flask, request, jsonify, session, render_template, redirect, url_for, flash
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from werkzeug.security import generate_password_hash, check_password_hash
from sqlalchemy.exc import IntegrityError
from flask_migrate import Migrate
import pymysql
import csv
import os
from datetime import datetime, timedelta
import pandas as pd
from functools import wraps
import json
import traceback

pymysql.install_as_MySQLdb()
from models import db, User, Recipe, Admin  # Update this import path if needed
from backend.recommendation import DietRecommender

app = Flask(__name__)
CORS(app)
# Database configuration
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://noman:noman@127.0.0.1/diet_database'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = 'your_secret_key_here'

db.init_app(app)
migrate = Migrate(app, db)

# Add this at the top of your file, after the imports
recipes = []  # Define recipes as a global variable

# Add these helper functions at the top of your file
def safe_int(value):
    """Safely convert value to integer"""
    try:
        return int(float(value)) if value else 0
    except (ValueError, TypeError):
        return 0

def safe_float(value):
    """Safely convert value to float"""
    try:
        return float(value) if value else 0.0
    except (ValueError, TypeError):
        return 0.0

def safe_bool(value):
    """Safely convert value to boolean"""
    if isinstance(value, bool):
        return value
    if isinstance(value, str):
        return value.lower() in ('true', '1', 'yes', 'y')
    if isinstance(value, (int, float)):
        return bool(value)
    return False

# Function to parse CSV and load recipes into the database
def parse_and_load_recipes(csv_file_path):
    try:
        # Clear existing recipes
        Recipe.query.delete()
        db.session.commit()
        
        recipes = []
        df = pd.read_csv(csv_file_path)
        
        # Replace NaN values with appropriate defaults
        df = df.fillna({
            'name': '',
            'image': '',
            'serving_size': 1,
            'prep_time_in_mins': 0,
            'cook_time_in_mins': 0,
            'ingredients': '',
            'instructions': '',  # New field
            'is_vegetarian': False,
            'is_breakfast': False,
            'is_lunch': False,
            'is_snack': False,
            'is_dinner': False,
            'energy_per_serving_kcal': 0.0,
            'carbohydrate_per_serving_g': 0.0,
            'protein_per_serving_g': 0.0,
            'fat_per_serving_g': 0.0,
            'fiber_per_serving_g': 0.0
        })
        
        for _, row in df.iterrows():
            recipe = Recipe(
                name=str(row['name']),
                image=str(row.get('image', '')),
                serving_size=int(float(row.get('serving_size', 1))),
                prep_time_in_mins=int(float(row.get('prep_time_in_mins', 0))),
                cook_time_in_mins=int(float(row.get('cook_time_in_mins', 0))),
                ingredients=str(row.get('ingredients', '')),
                instructions=str(row.get('instructions', '')),  # New field
                is_vegetarian=bool(row.get('is_vegetarian', False)),
                is_breakfast=bool(row.get('is_breakfast', False)),
                is_lunch=bool(row.get('is_lunch', False)),
                is_snack=bool(row.get('is_snack', False)),
                is_dinner=bool(row.get('is_dinner', False)),
                energy_per_serving_kcal=float(row.get('energy_per_serving_kcal', 0)),
                carbohydrate_per_serving_g=float(row.get('carbohydrate_per_serving_g', 0)),
                protein_per_serving_g=float(row.get('protein_per_serving_g', 0)),
                fat_per_serving_g=float(row.get('fat_per_serving_g', 0)),
                fiber_per_serving_g=float(row.get('fiber_per_serving_g', 0))
            )
            recipes.append(recipe)
        
        # Bulk insert with error handling
        try:
            db.session.bulk_save_objects(recipes)
            db.session.commit()
            print(f"Successfully loaded {len(recipes)} recipes")
            return True
        except Exception as e:
            print(f"Error during bulk insert: {str(e)}")
            db.session.rollback()
            return False
        
    except Exception as e:
        print(f"Error loading recipes: {str(e)}")
        db.session.rollback()
        return False

# Load recipes when the app starts
def load_recipes():
    csv_file_path = 'recipes_final.csv'
    if not os.path.exists(csv_file_path):
        print(f"Warning: {csv_file_path} not found")
        return []
    return parse_and_load_recipes(csv_file_path)

# Add this new function
def create_app():
    with app.app_context():
        db.create_all()
        load_recipes()
    return app

@app.route('/')
def index():
    if session.get('logged_in'):
        if session.get('is_admin'):
            return redirect(url_for('admin_dashboard'))
        return redirect(url_for('dashboard'))
    return render_template('index.html')

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'GET':
        return render_template('signup.html')
    elif request.method == 'POST':
        data = request.form
        hashed_password = generate_password_hash(data['password'])
        new_user = User(username=data['username'], email=data['email'], password_hash=hashed_password)
        try:
            db.session.add(new_user)
            db.session.commit()
            session['user_id'] = new_user.id
            session['logged_in'] = True
            session['username'] = new_user.username
            session['is_admin'] = False
            return redirect(url_for('dashboard'))
        except IntegrityError:
            db.session.rollback()
            flash('Username or email already exists', 'error')
            return redirect(url_for('signup'))

@app.route('/admin/login', methods=['GET'])
def admin_login_page():
    return render_template('login.html', login_type='admin')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        login_type = request.form['login_type']

        if login_type == 'admin':
            admin = Admin.query.filter_by(username=username).first()
            if admin and admin.password == password:
                session['logged_in'] = True
                session['username'] = username
                session['is_admin'] = True
                session['admin_id'] = admin.id
                flash('Welcome Admin!', 'success')
                return redirect(url_for('admin_dashboard'))
        else:
            user = User.query.filter_by(username=username).first()
            if user and user.check_password(password):
                session['logged_in'] = True
                session['username'] = username
                session['user_id'] = user.id
                session['is_admin'] = False
                flash('Login successful!', 'success')
                return redirect(url_for('dashboard'))
        
        flash('Invalid credentials', 'error')
    return render_template('login.html', login_type='user')

@app.route('/logout')
def logout():
    session.clear()
    flash('You have been logged out', 'success')
    return redirect(url_for('index'))

# Add this decorator to protect routes
def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not session.get('logged_in'):
            flash('Please login first', 'error')
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function

# Example of protected route
@app.route('/profile')
@login_required
def profile():
    user = User.query.get(session['user_id'])
    return render_template('profile.html', user=user)

def get_bmi_category(bmi):
    if bmi < 18.5:
        return 'Underweight'
    elif 18.5 <= bmi < 25:
        return 'Normal weight'
    elif 25 <= bmi < 30:
        return 'Overweight'
    elif 30 <= bmi < 35:
        return 'Obesity Class I'
    elif 35 <= bmi < 40:
        return 'Obesity Class II'
    else:
        return 'Obesity Class III'

@app.route('/calculate_diet', methods=['POST'])
def calculate_diet():
    if 'user_id' not in session:
        return jsonify({'error': 'Not logged in'}), 401
        
    user = User.query.get(session['user_id'])
    recommender = DietRecommender()
    
    nutritional_needs = recommender.calculate_nutritional_needs(user)
    
    meal_plan = {
        'breakfast': recommender.recommend_meals(user, 'breakfast'),
        'lunch': recommender.recommend_meals(user, 'lunch'),
        'dinner': recommender.recommend_meals(user, 'dinner'),
        'snacks': recommender.recommend_meals(user, 'snacks')
    }
    
    return jsonify({
        'bmi': {
            'value': round(nutritional_needs['bmi'], 1),
            'category': get_bmi_category(nutritional_needs['bmi'])
        },
        'calories': {
            'total': round(nutritional_needs['calories']),
            'breakfast': round(nutritional_needs['calories'] * 0.25),
            'lunch': round(nutritional_needs['calories'] * 0.35),
            'dinner': round(nutritional_needs['calories'] * 0.30),
            'snacks': round(nutritional_needs['calories'] * 0.10)
        },
        'nutritional_values': {
            'Protein (g)': round(nutritional_needs['protein']),
            'Carbs (g)': round(nutritional_needs['carbs']),
            'Fat (g)': round(nutritional_needs['fat']),
            'Fiber (g)': round(nutritional_needs['fiber'])
        },
        'meals': {
            meal_type: [
                {
                    'name': recipe.name,
                    'image': recipe.image,
                    'serving_size': recipe.serving_size,
                    'energy_per_serving_kcal': recipe.energy_per_serving_kcal,
                    'protein_per_serving_g': recipe.protein_g,
                    'carbohydrate_per_serving_g': recipe.carbohydrate_g,
                    'fat_per_serving_g': recipe.fat_g,
                    'fiber_per_serving_g': recipe.fiber_g,
                    'ingredients': recipe.ingredients,
                    'instructions': recipe.instructions
                } for recipe in recipes
            ] for meal_type, recipes in meal_plan.items()
        }
    })

@app.route('/admin_dashboard')
def admin_dashboard():
    if not session.get('is_admin'):
        flash('Unauthorized access', 'error')
        return redirect(url_for('login'))
    
    try:
        # Get recipes from database instead of CSV
        recipes = Recipe.query.all()
        return render_template('admin_dashboard.html', recipes=recipes)
    except Exception as e:
        flash(f'Error loading dashboard: {str(e)}', 'error')
        return redirect(url_for('login'))

@app.route('/admin/recipe', methods=['GET', 'POST'])
def add_recipe():
    if 'admin_id' not in session:
        flash('Unauthorized access', 'error')
        return redirect(url_for('login'))
    
    if request.method == 'POST':
        try:
            new_recipe = Recipe(
                name=request.form['name'],
                image=request.form['image'],
                serving_size=safe_int(request.form['serving_size']),
                prep_time_in_mins=safe_int(request.form['prep_time_in_mins']),
                cook_time_in_mins=safe_int(request.form['cook_time_in_mins']),
                ingredients=request.form['ingredients'],
                is_vegetarian=safe_bool(request.form.get('is_vegetarian')),
                is_breakfast=safe_bool(request.form.get('is_breakfast')),
                is_lunch=safe_bool(request.form.get('is_lunch')),
                is_snack=safe_bool(request.form.get('is_snack')),
                is_dinner=safe_bool(request.form.get('is_dinner')),
                energy_per_serving_kcal=safe_float(request.form['energy_per_serving_kcal']),
                carbohydrate_per_serving_g=safe_float(request.form['carbohydrate_per_serving_g']),
                protein_per_serving_g=safe_float(request.form['protein_per_serving_g']),
                fat_per_serving_g=safe_float(request.form['fat_per_serving_g']),
                fiber_per_serving_g=safe_float(request.form['fiber_per_serving_g'])
            )
            
            db.session.add(new_recipe)
            db.session.commit()
            flash('Recipe added successfully!', 'success')
            return redirect(url_for('admin_dashboard'))
            
        except Exception as e:
            db.session.rollback()
            flash(f'Error adding recipe: {str(e)}', 'error')
            return redirect(url_for('add_recipe'))
    
    return render_template('add_recipe.html')

@app.route('/admin/recipe/<int:recipe_id>', methods=['PUT', 'DELETE'])
def manage_recipe(recipe_id):
    if 'admin_id' not in session:
        return jsonify({'error': 'Unauthorized'}), 401
    
    if request.method == 'DELETE':
        # Delete recipe from CSV
        recipes = []
        with open('recipes.csv', 'r', encoding='utf-8') as file:
            reader = csv.DictReader(file)
            recipes = [r for r in reader if r['id'] != str(recipe_id)]
        
        with open('recipes.csv', 'w', newline='', encoding='utf-8') as file:
            writer = csv.DictWriter(file, fieldnames=recipes[0].keys())
            writer.writeheader()
            writer.writerows(recipes)
        
        return jsonify({'success': True})
    
    elif request.method == 'PUT':
        # Update recipe in CSV
        data = request.form
        recipes = []
        with open('recipes.csv', 'r', encoding='utf-8') as file:
            reader = csv.DictReader(file)
            recipes = list(reader)
            for recipe in recipes:
                if recipe['id'] == str(recipe_id):
                    recipe.update(data)
        
        with open('recipes.csv', 'w', newline='', encoding='utf-8') as file:
            writer = csv.DictWriter(file, fieldnames=recipes[0].keys())
            writer.writeheader()
            writer.writerows(recipes)
        
        return jsonify({'success': True})

@app.route('/admin/recipe/<recipe_name>', methods=['GET'])
def get_recipe(recipe_name):
    with open('recipes.csv', 'r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        for recipe in reader:
            if recipe['name'] == recipe_name:
                return jsonify(recipe)
    return jsonify({'error': 'Recipe not found'}), 404

@app.route('/admin/recipe/<recipe_name>', methods=['DELETE'])
def delete_recipe(recipe_name):
    if 'admin_id' not in session:
        return jsonify({'success': False, 'message': 'Unauthorized'}), 401
    
    try:
        recipe = Recipe.query.filter_by(name=recipe_name).first()
        if recipe:
            db.session.delete(recipe)
            db.session.commit()
            return jsonify({'success': True})
        return jsonify({'success': False, 'message': 'Recipe not found'}), 404
    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'message': str(e)}), 500

@app.route('/admin/recipe/new', methods=['GET', 'POST'])
def create_recipe():
    if 'admin_id' not in session:
        return jsonify({'error': 'Unauthorized'}), 401
    
    if request.method == 'POST':
        data = request.form
        with open('recipes.csv', 'a', newline='', encoding='utf-8') as file:
            writer = csv.writer(file)
            writer.writerow([
                data.get('name', ''),
                data.get('image', ''),
                data.get('serving_size', ''),
                data.get('prep_time_in_mins', ''),
                data.get('cook_time_in_mins', ''),
                data.get('ingredients', ''),
                data.get('ingredients_name', ''),
                data.get('ingredients_quantity_gram', ''),
                data.get('is_vegetarian', '0'),
                data.get('is_breakfast', '0'),
                data.get('is_lunch', '0'),
                data.get('is_snack', '0'),
                data.get('is_dinner', '0'),
                data.get('energy_per_serving_kcal', '0'),
                data.get('carbohydrate_per_serving_g', '0'),
                data.get('protein_per_serving_g', '0'),
                data.get('fat_per_serving_g', '0'),
                data.get('fiber_per_serving_g', '0')
            ])
        flash('Recipe added successfully!', 'success')
        return redirect(url_for('admin_dashboard'))
    
    return render_template('add_recipe.html')

@app.route('/admin/recipe/edit/<recipe_name>', methods=['GET', 'POST'])
def edit_recipe(recipe_name):
    if 'admin_id' not in session:
        return redirect(url_for('login'))
    
    if request.method == 'GET':
        recipe = Recipe.query.filter_by(name=recipe_name).first()
        if recipe is None:
            flash('Recipe not found', 'error')
            return redirect(url_for('admin_dashboard'))
        return render_template('edit_recipe.html', recipe=recipe)
    
    elif request.method == 'POST':
        recipe = Recipe.query.filter_by(name=recipe_name).first()
        if recipe is None:
            flash('Recipe not found', 'error')
            return redirect(url_for('admin_dashboard'))
        
        try:
            recipe.name = request.form['name']
            recipe.image = request.form['image']
            recipe.serving_size = int(request.form['serving_size'])
            recipe.prep_time_in_mins = int(request.form['prep_time_in_mins'])
            recipe.cook_time_in_mins = int(request.form['cook_time_in_mins'])
            recipe.ingredients = request.form['ingredients']
            recipe.instructions = request.form['instructions']
            recipe.energy_per_serving_kcal = float(request.form['energy_per_serving_kcal']) if request.form['energy_per_serving_kcal'] else None
            recipe.carbohydrate_g = float(request.form['carbohydrate_g']) if request.form['carbohydrate_g'] else None
            recipe.protein_g = float(request.form['protein_g']) if request.form['protein_g'] else None
            recipe.fat_g = float(request.form['fat_g']) if request.form['fat_g'] else None
            recipe.fiber_g = float(request.form['fiber_g']) if request.form['fiber_g'] else None
            recipe.is_vegetarian = bool(request.form.get('is_vegetarian'))
            recipe.is_breakfast = bool(request.form.get('is_breakfast'))
            recipe.is_lunch = bool(request.form.get('is_lunch'))
            recipe.is_snack = bool(request.form.get('is_snack'))
            recipe.is_dinner = bool(request.form.get('is_dinner'))
            
            db.session.commit()
            flash('Recipe updated successfully!', 'success')
            return redirect(url_for('admin_dashboard'))
        except Exception as e:
            db.session.rollback()
            flash(f'Error updating recipe: {str(e)}', 'error')
            return redirect(url_for('edit_recipe', recipe_name=recipe_name))

@app.route('/generate_meal_plan', methods=['GET', 'POST'])
@login_required  # Add this decorator to ensure user is logged in
def generate_meal_plan():
    if request.method == 'GET':
        user = User.query.get(session['user_id'])  # Get the current user
        return render_template('meal_plan_form.html', user=user)
        
    try:
        # Create a temporary user object from form data
        class TempUser:
            def __init__(self, form_data):
                self.age = int(form_data.get('age', 0))
                self.height = float(form_data.get('height', 0))
                self.weight = float(form_data.get('weight', 0))
                self.sex = form_data.get('gender', 'Male')
                self.activity_level = int(form_data.get('activity_level', 3))
                self.goal = form_data.get('goal', 'Maintain weight')
                self.dietary_preference = form_data.get('dietary_preference', 'non-vegetarian')

        # Create user object from form data
        user = TempUser(request.form)
        
        # Store the current meal plan's dietary preference in session
        session['current_meal_plan_preference'] = user.dietary_preference
        
        # Get selected meal type
        meal_type = request.form.get('meal_type')
        
        # Initialize recommender
        recommender = DietRecommender()
        
        # Calculate nutritional needs
        nutritional_needs = recommender.calculate_nutritional_needs(user)
        
        # Calculate meal-specific calories
        meal_calories = {
            'breakfast': round(nutritional_needs['calories'] * 0.25),
            'lunch': round(nutritional_needs['calories'] * 0.35),
            'dinner': round(nutritional_needs['calories'] * 0.30),
            'snacks': round(nutritional_needs['calories'] * 0.10)
        }

        # Get recommendations only for selected meal type
        meal_plan = {
            meal_type: recommender.recommend_meals(user, meal_type)
        }

        diet_data = {
            'bmi': recommender.calculate_bmi(user),
            'calories': {
                'total': round(nutritional_needs['calories']),
                meal_type: meal_calories[meal_type]
            },
            'nutritional_values': {
                'Protein (g)': round(nutritional_needs['protein']),
                'Carbs (g)': round(nutritional_needs['carbs']),
                'Fat (g)': round(nutritional_needs['fat']),
                'Fiber (g)': round(nutritional_needs['fiber'])
            },
            'meals': {
                meal_type: [{
                    'name': recipe.name,
                    'image': recipe.image,
                    'serving_size': recipe.serving_size,
                    'energy_per_serving_kcal': recipe.energy_per_serving_kcal,
                    'protein_per_serving_g': recipe.protein_per_serving_g,
                    'carbohydrate_per_serving_g': recipe.carbohydrate_per_serving_g,
                    'fat_per_serving_g': recipe.fat_per_serving_g,
                    'fiber_per_serving_g': recipe.fiber_per_serving_g,
                    'ingredients': recipe.ingredients,
                    'instructions': recipe.instructions
                } for recipe in meal_plan[meal_type]]
            }
        }

        # Render the template with the diet_data
        return render_template('recommendations.html', diet_data=diet_data)
                             
    except Exception as e:
        print(f"Error in generate_meal_plan: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/edit_profile', methods=['GET', 'POST'])
@login_required
def edit_profile():
    user = User.query.get(session['user_id'])
    
    if request.method == 'POST':
        try:
            # Update user information
            user.name = request.form.get('name')
            user.age = int(request.form.get('age', 0))
            user.sex = request.form.get('sex')
            user.weight = float(request.form.get('weight', 0))
            user.height = float(request.form.get('height', 0))
            user.activity_level = request.form.get('activity_level')  # This should match the select options
            user.goal = request.form.get('goal')
            user.dietary_restrictions = request.form.get('dietary_restrictions', '')
            
            # Validate required fields
            if not all([user.name, user.age, user.sex, user.weight, user.height, user.activity_level, user.goal]):
                flash('Please fill in all required fields', 'error')
                return render_template('edit_profile.html', user=user)
            
            db.session.commit()
            flash('Profile updated successfully!', 'success')
            return redirect(url_for('dashboard'))
            
        except (ValueError, TypeError) as e:
            db.session.rollback()
            flash('Please enter valid numbers for age, weight, and height', 'error')
        except Exception as e:
            db.session.rollback()
            flash(f'Error updating profile: {str(e)}', 'error')
    
    return render_template('edit_profile.html', 
                         user=user,
                         activity_levels=['Sedentary', 'Light', 'Moderate', 'Very Active', 'Super Active'],
                         goals=['Maintain', 'Weight loss', 'Extreme weight loss', 'Weight gain'])

@app.route('/dashboard')
@login_required
def dashboard():
    user = User.query.get(session.get('user_id'))
    
    # Check if user exists
    if not user:
        flash('User not found. Please log in again.', 'error')
        return redirect(url_for('login'))
    print(f"User: {user.name}")
    print(f"User height: {user.height}")
    print(f"User age: {user.age}")
    print(f"User activity level: {user.activity_level}")
    print(f"User goal: {user.goal}")


    
    # Check if user profile is complete
    if not all([user.weight, user.height, user.age, user.activity_level, user.goal]):
        flash('Please complete your profile first', 'warning')
        return redirect(url_for('edit_profile'))
    
    try:
        recommender = DietRecommender()
        
        # Define activity level multipliers
        activity_multipliers = {
            'sedentary': 1.2,      # Little or no exercise
            'light': 1.375,        # Light exercise/sports 1-3 days/week
            'moderate': 1.55,      # Moderate exercise/sports 3-5 days/week
            'very': 1.725,         # Hard exercise/sports 6-7 days/week
            'super': 1.9           # Very hard exercise/sports & physical job or training
        }
        
        # Get activity multiplier based on user's activity level, default to Moderate if not found
        activity_multiplier = activity_multipliers.get(user.activity_level, 1.55)
        print(f"User activity level: {user.activity_level}")
        print(f"Activity multiplier: {activity_multiplier}")
        
        # Calculate BMI and BMI-based calories
        bmi_data = recommender.calculate_bmi(user)
        bmi_value = bmi_data['value']
        bmi_category = bmi_data['category']
        
        # Calculate BMR
        bmr = recommender.calculate_bmr(user)
        
        # BMI-based calorie calculation
        if bmi_value < 18.5:  # Underweight
            bmi_calories = round(bmr * activity_multiplier * 1.2)  # 20% surplusbmi_calories
        elif 18.5 <= bmi_value < 25:  # Normal weight
            bmi_calories = round(bmr * activity_multiplier)
        else:  # Overweight/Obese
            bmi_calories = round(bmr * activity_multiplier * 0.8)  # 20% deficit
        
        # Calculate goal-based calories
        maintenance_calories = bmr * activity_multiplier
        
        if user.goal == "lose":
            goal_calories = round(maintenance_calories * 0.8)  # 20% deficit
        elif user.goal == "extreme_lose":
            goal_calories = round(maintenance_calories * 0.6)  # 40% deficit
        elif user.goal == "gain":
            goal_calories = round(maintenance_calories * 1.2)  # 20% surplus
        else:  # maintain
            goal_calories = round(maintenance_calories)


        print(f"Goal calories: {goal_calories}")
        print(f"BMI calories: {bmi_calories}")
            
        # Load today's meal history
        history = load_meal_history()
        user_id = str(session['user_id'])
        today = datetime.now().strftime('%Y-%m-%d')
        today_meals = history.get(user_id, {}).get(today, {}).get('meals', {})
        
        # Calculate remaining calories
        total_calories_consumed = history.get(user_id, {}).get(today, {}).get('total_calories', 0)
        remaining_bmi_calories = bmi_calories - total_calories_consumed
        remaining_goal_calories= goal_calories - total_calories_consumed
        
        # Get meal recommendations and nutrition info
        nutritional_needs = recommender.calculate_nutritional_needs(user)
        meal_recommendations = {
            'breakfast': recommender.recommend_meals(user, 'breakfast')[0] if recommender.recommend_meals(user, 'breakfast') else None,
            'lunch': recommender.recommend_meals(user, 'lunch')[0] if recommender.recommend_meals(user, 'lunch') else None,
            'dinner': recommender.recommend_meals(user, 'dinner')[0] if recommender.recommend_meals(user, 'dinner') else None,
            'snack': recommender.recommend_meals(user, 'snack')[0] if recommender.recommend_meals(user, 'snack') else None
        }
        
        # Calculate nutrition percentages
        total_calories = nutritional_needs.get('calories', 2000)
        nutrition = {
            'protein': round(nutritional_needs.get('protein', 0)),
            'protein_percentage': min(round((nutritional_needs.get('protein', 0) / total_calories) * 400), 100),
            'carbs': round(nutritional_needs.get('carbs', 0)),
            'carbs_percentage': min(round((nutritional_needs.get('carbs', 0) / total_calories) * 400), 100),
            'fats': round(nutritional_needs.get('fat', 0)),
            'fats_percentage': min(round((nutritional_needs.get('fat', 0) / total_calories) * 400), 100)
        }
        
        return render_template('dashboard.html',
                             user=user,
                             bmi_value=bmi_value,
                             bmi_category=bmi_category,
                             bmi_calories=remaining_bmi_calories,
                             goal_calories=remaining_goal_calories,
                             activity_multiplier=activity_multiplier,
                             meal_recommendations=meal_recommendations,
                             nutrition=nutrition,
                             today_meals=today_meals)
                             
    except Exception as e:
        print(f"Dashboard error: {str(e)}")
        flash('Error loading dashboard. Please try again.', 'error')
        return redirect(url_for('edit_profile'))

@app.context_processor
def inject_now():
    return {'now': datetime.now()}

@app.route('/browse_recipes')
@login_required
def browse_recipes():
    recipes = Recipe.query.all()
    return render_template('view_recipes.html', recipes=recipes)
@app.route('/get_different_meals/<meal_type>')
@login_required
def get_different_meals(meal_type):
    try:
        user = db.session.get(User, session['user_id'])
        
        # Use the dietary preference from the current meal plan instead of user's default
        current_pref = session.get('current_meal_plan_preference', user.dietary_preference)
        
        # Debug prints
        print(f"User ID: {user.id}")
        print(f"Meal Type: {meal_type}")
        print(f"Current Meal Plan Preference: {current_pref}")  # Updated debug print
        
        # Normalize meal type
        meal_type = meal_type.lower()
        if meal_type == 'snack':
            meal_type = 'snacks'
        
        # Build the query
        query = Recipe.query
        
        # Add meal type filter
        if meal_type == 'snacks':
            query = query.filter(Recipe.is_snack == True)
        else:
            query = query.filter(getattr(Recipe, f'is_{meal_type}') == True)
        
        # Add dietary preference filter based on session preference
        if current_pref == 'vegetarian':
            query = query.filter(Recipe.is_vegetarian == True)
        
        # Get random recipes
        new_meals = query.order_by(db.func.random()).limit(3).all()
        
        # Debug print
        print(f"Found {len(new_meals)} meals")
        for meal in new_meals:
            print(f"- {meal.name} (Vegetarian: {meal.is_vegetarian})")
        
        if not new_meals:
            print("No meals found matching criteria")
            return jsonify({
                'success': False,
                'error': 'No meals found matching the criteria'
            }), 404
        
        # Format the response
        formatted_meals = []
        for recipe in new_meals:
            try:
                formatted_meal = {
                    'id': recipe.id,
                    'name': recipe.name,
                    'image': recipe.image or '',
                    'energy_per_serving_kcal': float(recipe.energy_per_serving_kcal or 0),
                    'protein_per_serving_g': float(recipe.protein_per_serving_g or 0),
                    'carbohydrate_per_serving_g': float(recipe.carbohydrate_per_serving_g or 0),
                    'fat_per_serving_g': float(recipe.fat_per_serving_g or 0),
                    'serving_size': int(recipe.serving_size or 1),
                    'meal_type': meal_type,
                    'is_vegetarian': recipe.is_vegetarian
                }
                formatted_meals.append(formatted_meal)
            except Exception as format_error:
                print(f"Error formatting meal {recipe.name}: {str(format_error)}")
                continue
        
        return jsonify({
            'success': True,
            'meals': formatted_meals
        })
        
    except Exception as e:
        print(f"Error in get_different_meals: {str(e)}")
        traceback.print_exc()
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

def load_meal_history():
    """Load meal history from JSON file"""
    history_file = 'meal_history.json'
    if os.path.exists(history_file):
        with open(history_file, 'r') as f:
            return json.load(f)
    return {}

def save_meal_history(history):
    """Save meal history to JSON file"""
    with open('meal_history.json', 'w') as f:
        json.dump(history, f, indent=4)

@app.route('/select_meal', methods=['POST'])
@login_required
def select_meal():
    try:
        data = request.json
        user_id = str(session['user_id'])
        today = datetime.now().strftime('%Y-%m-%d')
        
        # Get user from database to access daily_calorie_goal
        user = db.session.get(User, session['user_id'])
        if not user:
            return jsonify({
                'success': False,
                'message': 'User not found'
            }), 404
        
        # Load existing history
        history = load_meal_history()
        
        # Initialize user and date entries if they don't exist
        if user_id not in history:
            history[user_id] = {}
        if today not in history[user_id]:
            history[user_id][today] = {
                'meals': {},
                'total_calories': 0,
                'remaining_calories': user.daily_calorie_goal if hasattr(user, 'daily_calorie_goal') else 2000
            }
        
        # Verify meal_type is provided and valid
        if not data.get('meal_type'):
            return jsonify({
                'success': False,
                'message': 'Meal type is required'
            }), 400
            
        meal_type = data['meal_type'].lower()
        if meal_type not in ['breakfast', 'lunch', 'dinner', 'snack']:
            return jsonify({
                'success': False,
                'message': 'Invalid meal type'
            }), 400
        
        # Check if meal type already selected for today
        if meal_type in history[user_id][today]['meals']:
            return jsonify({
                'success': False,
                'message': f'You have already selected {meal_type} for today'
            }), 400
        
        # Add new meal (recipe_id is optional)
        history[user_id][today]['meals'][meal_type] = {
            'recipe_name': data['recipe_name'],
            'calories': float(data['calories']),
            'time_selected': datetime.now().strftime('%H:%M:%S'),
            'recipe_id': data.get('recipe_id', 0)  # Default to 0 if not provided
        }
        
        # Update calories
        history[user_id][today]['total_calories'] += float(data['calories'])
        history[user_id][today]['remaining_calories'] -= float(data['calories'])
        
        # Save updated history
        save_meal_history(history)
        
        return jsonify({
            'success': True,
            'calories_consumed': history[user_id][today]['total_calories'],
            'remaining_calories': history[user_id][today]['remaining_calories']
        })
        
    except Exception as e:
        print(f"Error selecting meal: {str(e)}")
        return jsonify({
            'success': False,
            'message': f'Error selecting meal: {str(e)}'
        }), 500

@app.route('/meal_history')
@login_required
def meal_history():
    user_id = str(session['user_id'])
    history = load_meal_history()
    user_history = history.get(user_id, {})
    
    return render_template('meal_history.html', history=user_history)

@app.route('/remove_meal', methods=['POST'])
@login_required
def remove_meal():
    try:
        data = request.json
        user_id = str(session['user_id'])
        today = datetime.now().strftime('%Y-%m-%d')
        
        # Load existing history
        history = load_meal_history()
        
        # Check if meal exists
        if (user_id not in history or 
            today not in history[user_id] or 
            data['meal_type'] not in history[user_id][today]['meals']):
            return jsonify({
                'success': False,
                'message': 'Meal not found'
            }), 404
        
        # Get calories of meal to be removed
        meal_calories = history[user_id][today]['meals'][data['meal_type']]['calories']
        
        # Remove meal and update calories
        del history[user_id][today]['meals'][data['meal_type']]
        history[user_id][today]['total_calories'] -= meal_calories
        history[user_id][today]['remaining_calories'] += meal_calories
        
        # Save updated history
        save_meal_history(history)
        
        return jsonify({
            'success': True,
            'calories_consumed': history[user_id][today]['total_calories'],
            'remaining_calories': history[user_id][today]['remaining_calories']
        })
        
    except Exception as e:
        print(f"Error removing meal: {str(e)}")
        return jsonify({
            'success': False,
            'message': f'Error removing meal: {str(e)}'
        }), 500

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
        
        # Load recipes from CSV
        csv_path = os.path.join(os.path.dirname(__file__), 'recipes_final.csv')
        print(f"Looking for recipes.csv at: {csv_path}")
        
        if parse_and_load_recipes(csv_path):
            print("Successfully loaded recipes")
        else:
            print("Failed to load recipes - please check the errors above")
            
    app.run(debug=True)

