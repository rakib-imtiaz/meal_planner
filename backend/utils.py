from datetime import datetime

def calculate_calories(weight, height, age, sex, goal):
    if sex == 'male':
        bmr = 10 * weight + 6.25 * height - 5 * age + 5
    else:
        bmr = 10 * weight + 6.25 * height - 5 * age - 161

    tdee = bmr * 1.55  # Moderate activity level
    if goal == 'gain':
        return int(tdee + 500)
    elif goal == 'lose':
        return int(tdee - 500)
    else:
        return int(tdee)

def reset_calories_if_needed(user):
    if datetime.now().date() > user.last_reset.date():
        user.remaining_calories = user.daily_calories
        user.last_reset = datetime.now()

