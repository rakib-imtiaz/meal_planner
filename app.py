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

pymysql.install_as_MySQLdb()
from models import db, User, Recipe, Admin  # Import Recipe model and Admin model
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

# Function to parse CSV and load recipes into the database
def parse_and_load_recipes(csv_file_path):
    recipes = []
    with open(csv_file_path, mode='r', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            try:
                # Safe conversion functions
                def safe_int(value, default=0):
                    try:
                        if value and value != 'Ellipsis':
                            return int(float(value))
                        return default
                    except (ValueError, TypeError):
                        return default

                def safe_float(value, default=0.0):
                    try:
                        if value and value != 'Ellipsis':
                            return float(value)
                        return default
                    except (ValueError, TypeError):
                        return default

                def safe_bool(value, default=False):
                    try:
                        if value and value != 'Ellipsis':
                            return bool(int(float(value)))
                        return default
                    except (ValueError, TypeError):
                        return default

                # Only include fields that exist in the Recipe model
                recipe = Recipe(
                    name=row.get('name', ''),
                    image=row.get('image', ''),
                    serving_size=safe_int(row.get('serving_size'), 1),
                    prep_time_in_mins=safe_int(row.get('prep_time_in_mins'), 0),
                    cook_time_in_mins=safe_int(row.get('cook_time_in_mins'), 0),
                    ingredients=row.get('ingredients', ''),
                    is_vegetarian=safe_bool(row.get('is_vegetarian')),
                    is_breakfast=safe_bool(row.get('is_breakfast')),
                    is_lunch=safe_bool(row.get('is_lunch')),
                    is_dinner=safe_bool(row.get('is_dinner')),
                    is_snack=safe_bool(row.get('is_snack')),
                    energy_per_serving_kcal=safe_float(row.get('energy_per_serving_kcal')),
                    carbohydrate_g=safe_float(row.get('carbohydrate_per_serving_g')),
                    protein_g=safe_float(row.get('protein_per_serving_g')),
                    fat_g=safe_float(row.get('fat_per_serving_g')),
                    fiber_g=safe_float(row.get('fiber_per_serving_g'))
                )
                recipes.append(recipe)
            except Exception as e:
                print(f"Error loading recipe {row.get('name', 'unknown')}: {str(e)}")
                continue

    return recipes

# Load recipes when the app starts
def load_recipes():
    csv_file_path = 'recipes.csv'
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
    if 'user_id' not in session:
        return render_template('index.html')
    return redirect(url_for('profile'))

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
            return redirect(url_for('profile'))
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
            admin = Admin.query.filter_by(
                username=username,
                password=password
            ).first()
            if admin:
                session['admin_id'] = admin.id
                return redirect(url_for('admin_dashboard'))
            else:
                flash('Invalid admin credentials', 'error')
        else:
            # Existing user login logic
            user = User.query.filter_by(username=username).first()
            if user and check_password_hash(user.password_hash, password):
                session['user_id'] = user.id
                return redirect(url_for('profile'))
            flash('Invalid credentials', 'error')

    return render_template('login.html', login_type='user')

@app.route('/logout', methods=['POST'])
def logout():
    session.pop('user_id', None)
    return redirect(url_for('index'))

@app.route('/profile', methods=['GET', 'POST'])
def profile():
    if 'user_id' not in session:
        return redirect(url_for('index'))

    user = User.query.get(session['user_id'])
    recommender = DietRecommender()
    diet_data = None

    if request.method == 'POST':
        try:
            # Update user information
            user.age = int(request.form['age'])
            user.height = float(request.form['height'])
            user.weight = float(request.form['weight'])
            user.sex = request.form['gender']
            user.activity_level = int(request.form['activity_level'])
            user.goal = request.form['goal']
            user.meals_per_day = int(request.form['meals_per_day'])
            user.is_vegetarian = request.form.get('dietary_preference') == 'vegetarian'
            
            db.session.commit()

            # Calculate diet plan
            nutritional_needs = recommender.calculate_nutritional_needs(user)
            meal_plan = {
                'breakfast': recommender.recommend_meals(user, 'breakfast'),
                'lunch': recommender.recommend_meals(user, 'lunch'),
                'dinner': recommender.recommend_meals(user, 'dinner'),
                'snacks': recommender.recommend_meals(user, 'snack')
            }

            # Structure diet_data to match template expectations
            diet_data = {
                'bmi': {
                    'value': round(nutritional_needs['bmi'], 1),
                    'category': get_bmi_category(nutritional_needs['bmi'])
                },
                'calorie_comparison': {
                    'total': round(nutritional_needs['calories']),
                    'maintenance': round(nutritional_needs['calories'])
                },
                'calories': {
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
                'meal_plan': {
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
            }

        except Exception as e:
            print(f"Error in profile route: {str(e)}")
            flash(f'Error generating diet plan: {str(e)}', 'error')
            return render_template('profile.html', user=user, diet_data=None)

    return render_template('profile.html', user=user, diet_data=diet_data)

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
        'snacks': recommender.recommend_meals(user, 'snack')
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

@app.route('/admin/dashboard')
def admin_dashboard():
    if 'admin_id' not in session:
        return redirect(url_for('login'))
    
    recipes = []
    with open('recipes.csv', 'r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        recipes = list(reader)
    
    return render_template('admin_dashboard.html', recipes=recipes)

@app.route('/admin/recipe', methods=['POST'])
def add_recipe():
    if 'admin_id' not in session:
        return jsonify({'error': 'Unauthorized'}), 401
    
    # Add recipe to CSV
    data = request.form
    with open('recipes.csv', 'a', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)
        writer.writerow([data['name'], data['ingredients'], ...])  # Add all fields
    
    return jsonify({'success': True})

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

@app.route('/admin/recipe/delete/<recipe_name>', methods=['POST'])
def delete_recipe(recipe_name):
    if 'admin_id' not in session:
        return jsonify({'error': 'Unauthorized'}), 401
    
    try:
        # Read all recipes
        recipes = []
        with open('recipes.csv', 'r', encoding='utf-8') as file:
            reader = csv.DictReader(file)
            fieldnames = reader.fieldnames
            recipes = list(reader)
        
        # Find and remove the recipe
        recipes = [r for r in recipes if r['name'].strip() != recipe_name.strip()]
        
        # Write back to CSV
        with open('recipes.csv', 'w', newline='', encoding='utf-8') as file:
            writer = csv.DictWriter(file, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(recipes)
        
        return jsonify({'success': True, 'message': 'Recipe deleted successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

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

if __name__ == '__main__':
    create_app()
    app.run(debug=True)
