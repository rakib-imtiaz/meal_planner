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
from models import db, User, Recipe  # Import Recipe model

app = Flask(__name__)
CORS(app)

# Database configuration
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://noman:noman@127.0.0.1/diet_database'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = 'your_secret_key_here'

db.init_app(app)
migrate = Migrate(app, db)

# Function to parse CSV and load recipes into the database
def parse_and_load_recipes(csv_file_path):
    with open(csv_file_path, mode='r', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)
        recipes = []
        for row in reader:
            # Map CSV data to Recipe model fields
            recipe = Recipe(
                name=row['name'],
                image=row.get('image', ''),
                serving_size=int(float(row['serving_size'])) if row['serving_size'] else None,
                prep_time_in_mins=int(float(row['prep_time_in_mins'])) if row['prep_time_in_mins'] else None,
                cook_time_in_mins=int(float(row['cook_time_in_mins'])) if row['cook_time_in_mins'] else None,
                ingredients=row['ingredients'],
                instructions=row.get('instructions', ''),
                energy_per_serving_kcal=float(row['energy_per_serving_kcal']) if row['energy_per_serving_kcal'] else None,
                carbohydrate_g=float(row['carbohydrate_per_serving_g']) if row['carbohydrate_per_serving_g'] else None,
                protein_g=float(row['protein_per_serving_g']) if row['protein_per_serving_g'] else None,
                fat_g=float(row['fat_per_serving_g']) if row['fat_per_serving_g'] else None,
                fiber_g=float(row['fiber_per_serving_g']) if row['fiber_per_serving_g'] else None,
                is_vegetarian=bool(int(float(row['is_vegetarian']))) if row['is_vegetarian'] else False,
                is_breakfast=bool(int(float(row['is_breakfast']))) if row['is_breakfast'] else False,
                is_lunch=bool(int(float(row['is_lunch']))) if row['is_lunch'] else False,
                is_snack=bool(int(float(row['is_snack']))) if row['is_snack'] else False,
                is_dinner=bool(int(float(row['is_dinner']))) if row['is_dinner'] else False
            )
            recipes.append(recipe)
    with app.app_context():
        for recipe in recipes:
            # Check if the recipe already exists to avoid duplicates
            existing_recipe = Recipe.query.filter_by(name=recipe.name).first()
            if not existing_recipe:
                db.session.add(recipe)
        db.session.commit()
    print("Recipes imported successfully!")

# Load recipes when the app starts
def load_recipes():
    csv_file_path = 'recipes.csv'  # Update with the correct path to your CSV file
    if os.path.exists(csv_file_path):
        parse_and_load_recipes(csv_file_path)
    else:
        print(f"CSV file not found at {csv_file_path}. Please check the file path.")

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

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'GET':
        return render_template('login.html')
    elif request.method == 'POST':
        data = request.form
        user = User.query.filter_by(username=data['username']).first()
        if user and check_password_hash(user.password_hash, data['password']):
            session['user_id'] = user.id
            return redirect(url_for('profile'))
        flash('Invalid username or password', 'error')
        return redirect(url_for('login'))

@app.route('/logout', methods=['POST'])
def logout():
    session.pop('user_id', None)
    return redirect(url_for('index'))

def generate_meal_plan(nutritional_values, meals_per_day, is_vegetarian=False):
    meal_plan = {'breakfast': [], 'lunch': [], 'dinner': [], 'snacks': []}
    remaining_macros = nutritional_values.copy()

    # Distribute macros across meals
    meal_macros_distribution = {
        'breakfast': {k: v * 0.25 for k, v in nutritional_values.items()},
        'lunch': {k: v * 0.35 for k, v in nutritional_values.items()},
        'dinner': {k: v * 0.30 for k, v in nutritional_values.items()},
        'snacks': {k: v * 0.10 for k, v in nutritional_values.items()}
    }

    for meal_time in meal_plan.keys():
        # Query recipes suitable for the meal time and dietary preference
        query = Recipe.query

        # Use the correct attribute name for each meal type
        if meal_time == 'breakfast':
            query = query.filter(Recipe.is_breakfast == True)
        elif meal_time == 'lunch':
            query = query.filter(Recipe.is_lunch == True)
        elif meal_time == 'dinner':
            query = query.filter(Recipe.is_dinner == True)
        elif meal_time == 'snacks':
            query = query.filter(Recipe.is_snack == True)  # Note: singular 'is_snack'

        if is_vegetarian:
            query = query.filter(Recipe.is_vegetarian == True)

        suitable_meals = query.all()

        # Find the best matching meal based on macronutrients
        best_meal = None
        min_macro_diff = float('inf')
        target_macros = meal_macros_distribution[meal_time]

        for meal in suitable_meals:
            # Skip meals with None values for macronutrients
            if meal.protein_g is None or meal.carbohydrate_g is None or meal.fat_g is None:
                continue
            
            macro_diff = (
                abs(meal.protein_g - target_macros['Protein (g)']) +
                abs(meal.carbohydrate_g - target_macros['Carbs (g)']) +
                abs(meal.fat_g - target_macros['Fat (g)'])
            )
            if macro_diff < min_macro_diff:
                min_macro_diff = macro_diff
                best_meal = meal

        if best_meal:
            meal_plan[meal_time].append({
                'name': best_meal.name,
                'image': best_meal.image,
                'serving_size': best_meal.serving_size,
                'prep_time_in_mins': best_meal.prep_time_in_mins,
                'cook_time_in_mins': best_meal.cook_time_in_mins,
                'energy_per_serving_kcal': best_meal.energy_per_serving_kcal,
                'carbohydrate_per_serving_g': best_meal.carbohydrate_g,
                'protein_per_serving_g': best_meal.protein_g,
                'fat_per_serving_g': best_meal.fat_g,
                'fiber_per_serving_g': best_meal.fiber_g,
                'ingredients': best_meal.ingredients,
                'instructions': best_meal.instructions
            })
            # Update remaining macros
            remaining_macros['Protein (g)'] -= best_meal.protein_g
            remaining_macros['Carbs (g)'] -= best_meal.carbohydrate_g
            remaining_macros['Fat (g)'] -= best_meal.fat_g
        else:
            # Handle case when no suitable meal is found
            meal_plan[meal_time].append({
                'name': 'No suitable meal found',
                'image': '',
                'serving_size': 0,
                'prep_time_in_mins': 0,
                'cook_time_in_mins': 0,
                'energy_per_serving_kcal': 0,
                'carbohydrate_per_serving_g': 0,
                'protein_per_serving_g': 0,
                'fat_per_serving_g': 0,
                'fiber_per_serving_g': 0,
                'ingredients': '',
                'instructions': ''
            })

    return meal_plan

@app.route('/profile', methods=['GET', 'POST'])
def profile():
    if 'user_id' not in session:
        return redirect(url_for('index'))

    user = User.query.get(session['user_id'])

    if request.method == 'POST':
        # Extract form data
        age = int(request.form['age'])
        height = float(request.form['height'])
        weight = float(request.form['weight'])
        gender = request.form['gender']
        activity = int(request.form['activity_level'])
        goal = request.form['goal']
        meals_per_day = int(request.form['meals_per_day'])
        dietary_preference = request.form.get('dietary_preference', 'non-vegetarian')

        # Calculate BMI
        bmi = weight / ((height / 100) ** 2)
        if bmi < 18.5:
            bmi_category = 'Underweight'
        elif 18.5 <= bmi < 25:
            bmi_category = 'Normal weight'
        elif 25 <= bmi < 30:
            bmi_category = 'Overweight'
        elif 30 <= bmi < 35:
            bmi_category = 'Obesity Class I'
        elif 35 <= bmi < 40:
            bmi_category = 'Obesity Class II'
        else:
            bmi_category = 'Obesity Class III'

        # Calculate BMR using Mifflin-St Jeor Equation
        if gender.lower() == 'male':
            bmr = 10 * weight + 6.25 * height - 5 * age + 5
        elif gender.lower() == 'female':
            bmr = 10 * weight + 6.25 * height - 5 * age - 161
        else:
            bmr = 10 * weight + 6.25 * height - 5 * age

        # Activity factor mapping
        activity_factors = {
            1: 1.2,    # Sedentary
            2: 1.375,  # Lightly active
            3: 1.55,   # Moderately active
            4: 1.725,  # Very active
            5: 1.9     # Super active
        }
        activity_multiplier = activity_factors.get(activity, 1.2)

        # Calculate TDEE
        tdee = bmr * activity_multiplier

        # Adjust calorie intake based on goal
        calorie_intake = {
            'Maintain weight': round(tdee),
            'Weight loss': round(tdee - 500),
            'Extreme weight loss': round(tdee - 1000),
            'Weight gain': round(tdee + 500)
        }

        # Ensure minimum calorie intake
        min_calories = 1200 if gender.lower() == 'female' else 1500
        for key in calorie_intake:
            if calorie_intake[key] < min_calories:
                calorie_intake[key] = min_calories

        # Macronutrient ratios
        macro_ratios = {
            'Maintain weight': {'Protein': 0.20, 'Carbs': 0.50, 'Fat': 0.30},
            'Weight loss': {'Protein': 0.30, 'Carbs': 0.40, 'Fat': 0.30},
            'Extreme weight loss': {'Protein': 0.35, 'Carbs': 0.35, 'Fat': 0.30},
            'Weight gain': {'Protein': 0.25, 'Carbs': 0.50, 'Fat': 0.25}
        }
        selected_calories = calorie_intake[goal]
        macros = macro_ratios[goal]

        # Calculate grams of each macronutrient
        protein_grams = (selected_calories * macros['Protein']) / 4
        carbs_grams = (selected_calories * macros['Carbs']) / 4
        fat_grams = (selected_calories * macros['Fat']) / 9

        # Build nutritional values dictionary
        nutritional_values = {
            'Protein (g)': round(protein_grams),
            'Carbs (g)': round(carbs_grams),
            'Fat (g)': round(fat_grams)
        }

        # Generate meal plan using the new function
        is_vegetarian = (dietary_preference.lower() == 'vegetarian')
        meal_plan = generate_meal_plan(nutritional_values, meals_per_day, is_vegetarian)

        # Build diet data
        diet_data = {
            'bmi': {
                'value': round(bmi, 1),
                'category': bmi_category
            },
            'calories': calorie_intake,
            'meals': meal_plan,
            'calorie_comparison': {
                'total': selected_calories,
                'maintenance': round(tdee)
            },
            'nutritional_values': nutritional_values
        }

        # Update user information in the database
        user.age = age
        user.height = height
        user.weight = weight
        user.sex = gender
        user.activity_level = activity
        user.goal = goal
        # Save dietary preference if your User model includes this field
        # user.dietary_preference = dietary_preference
        db.session.commit()

        return render_template('profile.html', user=user, diet_data=diet_data)

    return render_template('profile.html', user=user)

@app.route('/calculate_diet', methods=['POST'])
def calculate_diet():
    data = request.json
    # Extract form data
    age = int(data['age'])
    height = float(data['height'])
    weight = float(data['weight'])
    gender = data['gender']
    activity = int(data['activity_level'])
    goal = data['goal']
    meals_per_day = int(data['meals_per_day'])
    dietary_preference = data.get('dietary_preference', 'non-vegetarian')

    # Calculate BMI
    bmi = weight / ((height / 100) ** 2)
    if bmi < 18.5:
        bmi_category = 'Underweight'
    elif 18.5 <= bmi < 25:
        bmi_category = 'Normal weight'
    elif 25 <= bmi < 30:
        bmi_category = 'Overweight'
    elif 30 <= bmi < 35:
        bmi_category = 'Obesity Class I'
    elif 35 <= bmi < 40:
        bmi_category = 'Obesity Class II'
    else:
        bmi_category = 'Obesity Class III'

    # Calculate BMR using Mifflin-St Jeor Equation
    if gender.lower() == 'male':
        bmr = 10 * weight + 6.25 * height - 5 * age + 5
    elif gender.lower() == 'female':
        bmr = 10 * weight + 6.25 * height - 5 * age - 161
    else:
        bmr = 10 * weight + 6.25 * height - 5 * age

    # Activity factor mapping
    activity_factors = {
        1: 1.2,    # Sedentary
        2: 1.375,  # Lightly active
        3: 1.55,   # Moderately active
        4: 1.725,  # Very active
        5: 1.9     # Super active
    }
    activity_multiplier = activity_factors.get(activity, 1.2)

    # Calculate TDEE
    tdee = bmr * activity_multiplier

    # Adjust calorie intake based on goal
    calorie_intake = {
        'Maintain weight': round(tdee),
        'Weight loss': round(tdee - 500),
        'Extreme weight loss': round(tdee - 1000),
        'Weight gain': round(tdee + 500)
    }

    # Ensure minimum calorie intake
    min_calories = 1200 if gender.lower() == 'female' else 1500
    for key in calorie_intake:
        if calorie_intake[key] < min_calories:
            calorie_intake[key] = min_calories

    # Macronutrient ratios
    macro_ratios = {
        'Maintain weight': {'Protein': 0.20, 'Carbs': 0.50, 'Fat': 0.30},
        'Weight loss': {'Protein': 0.30, 'Carbs': 0.40, 'Fat': 0.30},
        'Extreme weight loss': {'Protein': 0.35, 'Carbs': 0.35, 'Fat': 0.30},
        'Weight gain': {'Protein': 0.25, 'Carbs': 0.50, 'Fat': 0.25}
    }
    selected_calories = calorie_intake[goal]
    macros = macro_ratios[goal]

    # Calculate grams of each macronutrient
    protein_grams = (selected_calories * macros['Protein']) / 4
    carbs_grams = (selected_calories * macros['Carbs']) / 4
    fat_grams = (selected_calories * macros['Fat']) / 9

    # Build nutritional values dictionary
    nutritional_values = {
        'Protein (g)': round(protein_grams),
        'Carbs (g)': round(carbs_grams),
        'Fat (g)': round(fat_grams)
    }

    # Generate meal plan
    is_vegetarian = (dietary_preference.lower() == 'vegetarian')
    meal_plan = generate_meal_plan(nutritional_values, meals_per_day, is_vegetarian)

    # Return updated data
    return jsonify({
        'bmi': {
            'value': round(bmi, 1),
            'category': bmi_category
        },
        'calories': calorie_intake,
        'meals': meal_plan,
        'calorie_comparison': {
            'total': selected_calories,
            'maintenance': round(tdee)
        },
        'nutritional_values': nutritional_values
    })

if __name__ == '__main__':
    create_app()
    app.run(debug=True)
