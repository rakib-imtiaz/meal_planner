from models import Recipe, User
import pandas as pd
import numpy as np
from sqlalchemy import and_

class DietRecommender:
    def __init__(self):
        self.activity_levels = {
            1: 1.2,    # Sedentary
            2: 1.375,  # Lightly active
            3: 1.55,   # Moderately active
            4: 1.725,  # Very active
            5: 1.9     # Super active
        }
        
        self.macro_ratios = {
            'Maintain weight': {'Protein': 0.20, 'Carbs': 0.50, 'Fat': 0.30},
            'Weight loss': {'Protein': 0.30, 'Carbs': 0.40, 'Fat': 0.30},
            'Extreme weight loss': {'Protein': 0.35, 'Carbs': 0.35, 'Fat': 0.30},
            'Weight gain': {'Protein': 0.25, 'Carbs': 0.50, 'Fat': 0.25}
        }

    def calculate_bmr(self, user):
        """Calculate Basal Metabolic Rate using Harris-Benedict equation"""
        if user.sex.lower() == 'female':
            return 10 * user.weight + 6.25 * user.height - 5 * user.age - 161
        return 10 * user.weight + 6.25 * user.height - 5 * user.age + 5

    def calculate_nutritional_needs(self, user):
        """Calculate daily nutritional needs based on user data"""
        bmr = self.calculate_bmr(user)
        tdee = bmr * self.activity_levels.get(user.activity_level, 1.2)
        
        # Calculate BMI
        height_in_meters = user.height / 100
        bmi = user.weight / (height_in_meters ** 2)
        
        # Get macro ratios based on goal
        macros = self.macro_ratios[user.goal]
        
        # Calculate daily calorie needs
        if user.goal == 'Weight loss':
            calories = tdee - 500
        elif user.goal == 'Extreme weight loss':
            calories = tdee - 1000
        elif user.goal == 'Weight gain':
            calories = tdee + 500
        else:
            calories = tdee
            
        # Ensure minimum calorie intake
        min_calories = 1200 if user.sex.lower() == 'female' else 1500
        calories = max(calories, min_calories)
        
        return {
            'bmi': bmi,
            'calories': calories,
            'protein': (calories * macros['Protein']) / 4,
            'carbs': (calories * macros['Carbs']) / 4,
            'fat': (calories * macros['Fat']) / 9,
            'fiber': 25  # Fixed daily fiber requirement
        }

    def get_meal_distribution(self, total_calories):
        """Distribute calories across meals"""
        return {
            'breakfast': total_calories * 0.25,
            'lunch': total_calories * 0.35,
            'dinner': total_calories * 0.30,
            'snacks': total_calories * 0.10
        }

    def recommend_meals(self, user, meal_type):
        """Generate meal recommendations based on user profile and meal type"""
        try:
            nutritional_needs = self.calculate_nutritional_needs(user)
            meal_calories = self.get_meal_distribution(nutritional_needs['calories'])[meal_type]
            
            # Query base
            query = Recipe.query.filter(
                and_(
                    getattr(Recipe, f'is_{meal_type}') == True,
                    Recipe.energy_per_serving_kcal <= meal_calories * 1.2,
                    Recipe.energy_per_serving_kcal >= meal_calories * 0.8
                )
            )
            
            # Apply dietary restrictions
            if user.is_vegetarian:
                query = query.filter(Recipe.is_vegetarian == True)
                
            # Get all potential recipes
            recipes = query.all()
            if not recipes:
                # If no recipes match the strict criteria, relax the calorie constraints
                query = Recipe.query.filter(
                    and_(
                        getattr(Recipe, f'is_{meal_type}') == True,
                        Recipe.energy_per_serving_kcal <= meal_calories * 1.5,
                        Recipe.energy_per_serving_kcal >= meal_calories * 0.5
                    )
                )
                if user.is_vegetarian:
                    query = query.filter(Recipe.is_vegetarian == True)
                recipes = query.all()
                
                if not recipes:
                    return []
                    
            # Convert to DataFrame for easier processing
            recipe_data = pd.DataFrame([{
                'id': r.id,
                'name': r.name,
                'energy': r.energy_per_serving_kcal,
                'protein': r.protein_g,
                'carbs': r.carbohydrate_g,
                'fat': r.fat_g,
                'fiber': r.fiber_g
            } for r in recipes])
            
            # Calculate similarity scores
            target_macros = pd.Series({
                'protein': nutritional_needs['protein'] * self.get_meal_distribution(1)[meal_type],
                'carbs': nutritional_needs['carbs'] * self.get_meal_distribution(1)[meal_type],
                'fat': nutritional_needs['fat'] * self.get_meal_distribution(1)[meal_type],
                'fiber': nutritional_needs['fiber'] * self.get_meal_distribution(1)[meal_type]
            })
            
            # Calculate weighted differences
            differences = np.abs(recipe_data[['protein', 'carbs', 'fat', 'fiber']] - target_macros)
            weights = pd.Series({'protein': 0.3, 'carbs': 0.3, 'fat': 0.2, 'fiber': 0.2})
            weighted_scores = (differences * weights).sum(axis=1)
            
            # Get top 3 recommendations
            recommended_ids = recipe_data.loc[weighted_scores.nsmallest(3).index, 'id']
            return Recipe.query.filter(Recipe.id.in_(recommended_ids)).all()
        except Exception as e:
            print(f"Error in recommend_meals: {str(e)}")
            return []

