from flask import jsonify, request
from models import db, User, Recipe
from utils import calculate_calories, reset_calories_if_needed
from datetime import datetime
from recommendation import recommend_recipes

def init_routes(app):
    @app.route('/api/signup', methods=['POST'])
    def signup():
        data = request.get_json()
        daily_calories = calculate_calories(
            data['weight'], data['height'], data['age'], data['sex'], data['goal']
        )
        new_user = User(
            username=data['username'],
            password=data['password'],
            name=data['name'],
            age=data['age'],
            sex=data['sex'],
            weight=data['weight'],
            height=data['height'],
            goal=data['goal'],
            is_vegan=data.get('is_vegan', False),
            daily_calories=daily_calories,
            remaining_calories=daily_calories,
            last_reset=datetime.now()
        )
        db.session.add(new_user)
        db.session.commit()
        return jsonify({"message": "User registered successfully!"}), 201

    @app.route('/api/login', methods=['POST'])
    def login():
        data = request.get_json()
        user = User.query.filter_by(username=data['username'], password=data['password']).first()
        if user:
            reset_calories_if_needed(user)
            return jsonify({
                "name": user.name,
                "daily_calories": user.daily_calories,
                "remaining_calories": user.remaining_calories
            }), 200
        else:
            return jsonify({"message": "Invalid credentials!"}), 401

    @app.route('/api/recipes', methods=['GET'])
    def get_recipes():
        username = request.args.get('username')
        user = User.query.filter_by(username=username).first()
        
        if user:
            recommended_recipes = recommend_recipes(user)
            return jsonify([{
                'name': recipe.name,
                'energy_per_serving_kcal': recipe.energy_per_serving_kcal,
                'protein_g': recipe.protein_g,
                'carbohydrate_g': recipe.carbohydrate_g,
                'fat_g': recipe.fat_g,
                'image': recipe.image,
                'is_vegetarian': recipe.is_vegetarian,
                'is_breakfast': recipe.is_breakfast,
                'is_lunch': recipe.is_lunch,
                'is_dinner': recipe.is_dinner,
                'is_snack': recipe.is_snack
            } for recipe in recommended_recipes]), 200
        else:
            return jsonify({"message": "User not found!"}), 404

    @app.route('/api/select_meal', methods=['POST'])
    def select_meal():
        data = request.get_json()
        user = User.query.filter_by(username=data['username']).first()
        recipe = Recipe.query.filter_by(name=data['recipe_name']).first()

        if user and recipe:
            user.remaining_calories -= recipe.energy_per_serving_kcal
            db.session.commit()

            if user.remaining_calories <= 0:
                return jsonify({
                    "remaining_calories": user.remaining_calories,
                    "message": "Congratulations! You've reached your calorie goal!"
                }), 200

            return jsonify({"remaining_calories": user.remaining_calories}), 200
        else:
            return jsonify({"message": "User or recipe not found!"}), 404

    @app.route('/api/user_profile', methods=['GET', 'PUT'])
    def user_profile():
        data = request.get_json()
        user = User.query.filter_by(username=data['username']).first()
        
        if request.method == 'GET':
            if user:
                return jsonify({
                    "name": user.name,
                    "age": user.age,
                    "sex": user.sex,
                    "weight": user.weight,
                    "height": user.height,
                    "goal": user.goal,
                    "is_vegan": user.is_vegan,
                    "activity_level": user.activity_level,
                    "dietary_restrictions": user.dietary_restrictions
                }), 200
            else:
                return jsonify({"message": "User not found!"}), 404
        
        elif request.method == 'PUT':
            if user:
                user.name = data.get('name', user.name)
                user.age = data.get('age', user.age)
                user.sex = data.get('sex', user.sex)
                user.weight = data.get('weight', user.weight)
                user.height = data.get('height', user.height)
                user.goal = data.get('goal', user.goal)
                user.is_vegan = data.get('is_vegan', user.is_vegan)
                user.activity_level = data.get('activity_level', user.activity_level)
                user.dietary_restrictions = data.get('dietary_restrictions', user.dietary_restrictions)
                
                db.session.commit()
                return jsonify({"message": "User profile updated successfully!"}), 200
            else:
                return jsonify({"message": "User not found!"}), 404
