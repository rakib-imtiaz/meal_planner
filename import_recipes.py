import csv
from models import db, Recipe
from your_app import app  # Replace 'your_app' with the name of your Flask app module

def parse_and_load_recipes(csv_file_path):
    with open(csv_file_path, mode='r', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)
        recipes = []
        for row in reader:
            # Map CSV data to Recipe model fields
            recipe = Recipe(
                name=row['name'],
                image=row['image'] if 'image' in row else None,
                serving_size=int(float(row['serving_size'])) if row['serving_size'] else None,
                prep_time_in_mins=int(float(row['prep_time_in_mins'])) if row['prep_time_in_mins'] else None,
                cook_time_in_mins=int(float(row['cook_time_in_mins'])) if row['cook_time_in_mins'] else None,
                ingredients=row['ingredients'],
                instructions=row['instructions'] if 'instructions' in row else "",
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

if __name__ == '__main__':
    csv_file_path = 'recipe.csv'  # Update with the correct path to your CSV file
    parse_and_load_recipes(csv_file_path)
