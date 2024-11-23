import traceback
from models import Recipe, User
import pandas as pd
import numpy as np
from sqlalchemy import and_

class DietRecommender:
    def __init__(self):
        self.activity_levels = {
            'Sedentary': 1.2,      # Little or no exercise
            'Light': 1.375,        # Light exercise/sports 1-3 days/week
            'Moderate': 1.55,      # Moderate exercise/sports 3-5 days/week
            'Very Active': 1.725,  # Hard exercise/sports 6-7 days/week
            'Super Active': 1.9    # Very hard exercise/sports & physical job
        }

    def calculate_bmr(self, user):
        if user.sex == 'Female':
            return 10 * user.weight + 6.25 * user.height - 5 * user.age - 161
        else:
            return 10 * user.weight + 6.25 * user.height - 5 * user.age + 5

    def calculate_bmi(self, user):
        height_in_meters = user.height / 100
        bmi = user.weight / (height_in_meters ** 2)
        
        # Determine BMI category
        if bmi < 18.5:
            category = "Underweight"
        elif 18.5 <= bmi < 25:
            category = "Normal"
        elif 25 <= bmi < 30:
            category = "Overweight"
        else:
            category = "Obese"
            
        return {"value": bmi, "category": category}

    def calculate_nutritional_needs(self, user):
        bmr = self.calculate_bmr(user)
        activity_multiplier = self.activity_levels.get(user.activity_level, 1.55)
        maintenance_calories = bmr * activity_multiplier

        # Adjust calories based on goal
        if user.goal == "Weight loss":
            total_calories = maintenance_calories * 0.8
        elif user.goal == "Extreme weight loss":
            total_calories = maintenance_calories * 0.6
        elif user.goal == "Weight gain":
            total_calories = maintenance_calories * 1.2
        else:  # Maintain weight
            total_calories = maintenance_calories

        return {
            'calories': total_calories,
            'protein': total_calories * 0.25 / 4,  # 25% protein
            'fat': total_calories * 0.25 / 9,      # 25% fat
            'carbs': total_calories * 0.5 / 4,     # 50% carbs
            'fiber': 25  # Fixed fiber requirement
        }

    def get_meal_distribution(self, total_calories):
        return {
            'breakfast': total_calories * 0.25,
            'lunch': total_calories * 0.35,
            'dinner': total_calories * 0.30,
            'snacks': total_calories * 0.10
        }

    def recommend_meals(self, user, meal_type):
        try:
            nutritional_needs = self.calculate_nutritional_needs(user)
            
            # Fix the meal type for snacks
            if meal_type.lower() == 'snack':
                meal_type = 'snacks'
            
            meal_calories = self.get_meal_distribution(nutritional_needs['calories'])[meal_type.lower()]
            
            # Print debug information
            print(f"Searching for {meal_type} recipes")
            dietary_pref = getattr(user, 'dietary_preference', 'non-vegetarian')
            print(f"User dietary preference: {dietary_pref}")
            
            # Base query with meal type and calorie range
            base_conditions = [
                Recipe.energy_per_serving_kcal.between(meal_calories * 0.8, meal_calories * 1.2)
            ]
            
            # Add meal type condition
            if meal_type.lower() == 'snacks':
                base_conditions.append(Recipe.is_snack == True)
            else:
                base_conditions.append(getattr(Recipe, f'is_{meal_type.lower().rstrip("s")}') == True)
            
            # Build initial query
            query = Recipe.query
            
            # Handle dietary preferences with wider calorie range for vegetarian options
            if dietary_pref == 'vegetarian':
                # Widen the calorie range for vegetarian options
                query = query.filter(
                    and_(
                        Recipe.is_vegetarian == True,
                        *base_conditions
                    )
                )
                
                # If no vegetarian options found, try with a wider calorie range
                potential_recipes = query.all()
                if not potential_recipes:
                    print("No vegetarian recipes found with strict calorie range, widening search...")
                    base_conditions = [
                        Recipe.energy_per_serving_kcal.between(meal_calories * 0.6, meal_calories * 1.4)
                    ]
                    if meal_type.lower() == 'snacks':
                        base_conditions.append(Recipe.is_snack == True)
                    else:
                        base_conditions.append(getattr(Recipe, f'is_{meal_type.lower().rstrip("s")}') == True)
                    
                    query = Recipe.query.filter(
                        and_(
                            Recipe.is_vegetarian == True,
                            *base_conditions
                        )
                    )
                    potential_recipes = query.all()
            else:
                # For non-vegetarian users, use original conditions
                query = query.filter(and_(*base_conditions))
                potential_recipes = query.all()
            
            # Debug print statements
            print(f"Found {len(potential_recipes)} potential recipes")
            for recipe in potential_recipes:
                print(f"Recipe: {recipe.name}, Vegetarian: {recipe.is_vegetarian}, Meal Type: {meal_type}, Calories: {recipe.energy_per_serving_kcal}")
            
            if not potential_recipes:
                print(f"No recipes found for {meal_type}")
                return []
                    
            # Convert to DataFrame for processing
            recipe_data = pd.DataFrame([{
                'id': recipe.id,
                'name': recipe.name,
                'energy_per_serving_kcal': recipe.energy_per_serving_kcal,
                'protein_per_serving_g': recipe.protein_per_serving_g,
                'carbohydrate_per_serving_g': recipe.carbohydrate_per_serving_g,
                'fat_per_serving_g': recipe.fat_per_serving_g,
                'fiber_per_serving_g': recipe.fiber_per_serving_g
            } for recipe in potential_recipes])
            
            # Calculate nutritional differences
            target_nutrition = pd.Series({
                'energy_per_serving_kcal': meal_calories,
                'protein_per_serving_g': nutritional_needs['protein'] * 0.25,
                'carbohydrate_per_serving_g': nutritional_needs['carbs'] * 0.25,
                'fat_per_serving_g': nutritional_needs['fat'] * 0.25,
                'fiber_per_serving_g': nutritional_needs['fiber'] * 0.25
            })
            
            differences = np.abs(recipe_data[target_nutrition.index] - target_nutrition)
            weights = pd.Series({
                'energy_per_serving_kcal': 0.4,
                'protein_per_serving_g': 0.2,
                'carbohydrate_per_serving_g': 0.2,
                'fat_per_serving_g': 0.1,
                'fiber_per_serving_g': 0.1
            })
            
            weighted_scores = (differences * weights).sum(axis=1)
            recommended_ids = recipe_data.loc[weighted_scores.nsmallest(3).index, 'id']
            final_recipes = Recipe.query.filter(Recipe.id.in_(recommended_ids)).all()
            
            return final_recipes
            
        except Exception as e:
            print(f"Error in recommend_meals: {str(e)}")
            traceback.print_exc()  # Add this to get full error traceback
            return []

