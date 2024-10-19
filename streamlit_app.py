import streamlit as st
import requests

# URL to your Flask backend
FLASK_BACKEND = 'http://127.0.0.1:5000'

def main():
    st.title("Automatic Diet Recommendation System")

    # Input fields for user data
    age = st.number_input("Age", min_value=0, step=1)
    height = st.number_input("Height (cm)", min_value=0.0, step=0.1)
    weight = st.number_input("Weight (kg)", min_value=0.0, step=0.1)
    gender = st.radio("Gender", ("Male", "Female"))
    activity_level = st.slider("Activity Level (1-5)", min_value=1, max_value=5, format="%d")
    goal = st.selectbox("Weight Loss Plan", ["Maintain weight", "Weight loss", "Extreme weight loss", "Weight gain"])
    meals_per_day = st.slider("Meals per Day", min_value=1, max_value=6)
    dietary_preference = st.selectbox("Dietary Preference", ["Non-vegetarian", "Vegetarian"])

    # Button to generate recommendations
    if st.button("Generate Meal Plan"):
        # Prepare data for API request
        data = {
            "age": age,
            "height": height,
            "weight": weight,
            "gender": gender,
            "activity_level": activity_level,
            "goal": goal,
            "meals_per_day": meals_per_day,
            "dietary_preference": dietary_preference
        }

        try:
            # Send data to Flask backend
            response = requests.post(f"{FLASK_BACKEND}/calculate_diet", json=data)

            if response.status_code == 200:
                # Display response from backend
                result = response.json()

                st.subheader("BMI CALCULATOR")
                st.text(f"BMI: {result['bmi']['value']} ({result['bmi']['category']})")

                st.subheader("CALORIES CALCULATOR")
                st.text(f"Daily Calories to {goal}: {result['calories'][goal]}")

                st.subheader("DIET RECOMMENDER")
                st.write("**Breakfast:**", ', '.join([meal['name'] for meal in result['meals']['breakfast']]))
                st.write("**Lunch:**", ', '.join([meal['name'] for meal in result['meals']['lunch']]))
                st.write("**Dinner:**", ', '.join([meal['name'] for meal in result['meals']['dinner']]))

                st.subheader("Calorie Comparison")
                st.write(f"Total Calories: {result['calorie_comparison']['total']}")
                st.write(f"Goal Calories: {result['calorie_comparison']['maintenance']}")

                st.subheader("Nutritional Values")
                st.write(f"Protein: {result['nutritional_values']['Protein (g)']} g")
                st.write(f"Carbs: {result['nutritional_values']['Carbs (g)']} g")
                st.write(f"Fat: {result['nutritional_values']['Fat (g)']} g")
            else:
                st.error("Failed to get a response from the backend")

        except requests.exceptions.RequestException as e:
            st.error(f"An error occurred: {e}")

if __name__ == "__main__":
    main()
