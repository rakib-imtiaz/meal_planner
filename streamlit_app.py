import streamlit as st
import pandas as pd
from models import User, Recipe, db
from app import create_app
from backend.routes import recommend_recipes

# Initialize the Flask app
app = create_app()

# Streamlit app
def main():
    st.title("MealMate - Your Personal Meal Planner")

    # Sidebar for user input
    st.sidebar.header("User Information")
    username = st.sidebar.text_input("Username")
    
    if username:
        with app.app_context():
            user = User.query.filter_by(username=username).first()
            if user:
                st.sidebar.success(f"Welcome, {user.name}!")
                st.sidebar.write(f"Age: {user.age}")
                st.sidebar.write(f"Goal: {user.goal}")
                
                # Main content
                st.header("Recommended Recipes")
                recommended_recipes = recommend_recipes(user)
                
                for recipe in recommended_recipes:
                    st.subheader(recipe.name)
                    col1, col2 = st.columns(2)
                    with col1:
                        st.image(recipe.image, use_column_width=True)
                    with col2:
                        st.write(f"Calories: {recipe.energy_per_serving_kcal} kcal")
                        st.write(f"Protein: {recipe.protein_g}g")
                        st.write(f"Carbs: {recipe.carbohydrate_g}g")
                        st.write(f"Fat: {recipe.fat_g}g")
                        if st.button(f"Select {recipe.name}"):
                            user.remaining_calories -= recipe.energy_per_serving_kcal
                            db.session.commit()
                            st.success(f"Added {recipe.name} to your meal plan!")
                            st.write(f"Remaining calories: {user.remaining_calories} kcal")
            else:
                st.sidebar.error("User not found. Please check the username.")
    else:
        st.write("Please enter a username in the sidebar to get started.")

if __name__ == "__main__":
    main()

