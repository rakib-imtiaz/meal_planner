import csv
from models import db, Recipe
from your_app import app  # Replace 'your_app' with the name of your Flask app module

def parse_and_load_recipes(csv_file_path):
    fieldnames = [
        'name', 'image', 'serving_size', 'prep_time_in_mins', 'cook_time_in_mins',
        'ingredients', 'instructions',  # Added instructions field
        'is_vegetarian', 'is_breakfast', 'is_lunch', 'is_snack', 'is_dinner',
        'energy_per_serving_kcal', 'carbohydrate_per_serving_g', 'protein_per_serving_g',
        'fat_per_serving_g', 'fiber_per_serving_g'
    ]
    
    with open(csv_file_path, mode='r', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile, fieldnames=fieldnames, delimiter=',')
        next(reader)  # Skip header row if present
        recipes = []
        
        for row in reader:
            if not row['name']:  # Skip empty rows
                continue
            try:
                recipe = Recipe(
                    name=row['name'].strip(),
                    image=row['image'].strip() if row['image'] else None,
                    serving_size=int(float(row['serving_size'])) if row['serving_size'] else None,
                    prep_time_in_mins=int(float(row['prep_time_in_mins'])) if row['prep_time_in_mins'] else None,
                    cook_time_in_mins=int(float(row['cook_time_in_mins'])) if row['cook_time_in_mins'] else None,
                    ingredients=row['ingredients'].strip() if row['ingredients'] else None,
                    instructions=row['instructions'].strip() if row['instructions'] else "",  # Added instructions
                    is_vegetarian=bool(int(float(row['is_vegetarian']))) if row['is_vegetarian'] else False,
                    is_breakfast=bool(int(float(row['is_breakfast']))) if row['is_breakfast'] else False,
                    is_lunch=bool(int(float(row['is_lunch']))) if row['is_lunch'] else False,
                    is_snack=bool(int(float(row['is_snack']))) if row['is_snack'] else False,
                    is_dinner=bool(int(float(row['is_dinner']))) if row['is_dinner'] else False,
                    energy_per_serving_kcal=float(row['energy_per_serving_kcal']) if row['energy_per_serving_kcal'] else None,
                    carbohydrate_per_serving_g=float(row['carbohydrate_per_serving_g']) if row['carbohydrate_per_serving_g'] else None,
                    protein_per_serving_g=float(row['protein_per_serving_g']) if row['protein_per_serving_g'] else None,
                    fat_per_serving_g=float(row['fat_per_serving_g']) if row['fat_per_serving_g'] else None,
                    fiber_per_serving_g=float(row['fiber_per_serving_g']) if row['fiber_per_serving_g'] else None
                )
                recipes.append(recipe)
            except Exception as e:
                print(f"Error processing recipe {row['name']}: {str(e)}")
                continue

    with app.app_context():
        for recipe in recipes:
            existing_recipe = Recipe.query.filter_by(name=recipe.name).first()
            if not existing_recipe:
                db.session.add(recipe)
        db.session.commit()
    print("Recipes imported successfully!")

if __name__ == '__main__':
    csv_file_path = 'recipes.csv'  # Fixed file path
    parse_and_load_recipes(csv_file_path)
