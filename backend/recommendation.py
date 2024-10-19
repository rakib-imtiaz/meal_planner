from models import Recipe, User

def recommend_recipes(user):
    recipes = Recipe.query.all()
    recommended = []
    
    for recipe in recipes:
        if user.is_vegan and not recipe.is_vegetarian:
            continue
        
        if user.dietary_restrictions and user.dietary_restrictions in recipe.ingredients:
            continue
        
        if user.goal == 'lose' and recipe.energy_per_serving_kcal > 500:
            continue
        
        if user.goal == 'gain' and recipe.energy_per_serving_kcal < 300:
            continue
        
        recommended.append(recipe)
    
    return recommended[:10]  # Return top 10 recommended recipes

