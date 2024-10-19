// Fetch the selected recipe details when the page loads
document.addEventListener('DOMContentLoaded', fetchRecipeInfo);

async function fetchRecipeInfo() {
    const recipeName = localStorage.getItem('selectedRecipe');  // Get recipe name from localStorage

    if (!recipeName) {
        alert('No recipe selected. Please go back and select a recipe.');
        window.location.href = 'select_meal.html';  // Redirect if no recipe name is found
        return;
    }

    try {
        // Make the API request to fetch all recipes
        const response = await fetch('http://127.0.0.1:5000/api/recipes');
        const recipes = await response.json();

        console.log('Fetched recipes:', recipes);  // Debugging log

        // Find the matching recipe using the 'name' field from the CSV
        const recipe = recipes.find(r => r.name.toLowerCase() === recipeName.toLowerCase());

        if (recipe) {
            displayRecipeDetails(recipe);
        } else {
            document.getElementById('recipeDetails').innerHTML = `<p>Recipe not found!</p>`;
        }
    } catch (error) {
        console.error('Error fetching recipe info:', error);
    }
}

function displayRecipeDetails(recipe) {
    const recipeDetails = `
        <h3>${recipe.name}</h3>
        <p><strong>Calories:</strong> ${recipe.energy_per_serving_kcal} kcal</p>
        <p><strong>Protein:</strong> ${recipe.protein_per_serving_g} g</p>
        <p><strong>Fat:</strong> ${recipe.fat_per_serving_g} g</p>
        <p><strong>Carbohydrates:</strong> ${recipe.carbohydrate_per_serving_g} g</p>
        <button class="btn btn-success mt-3" onclick="selectRecipe(${recipe.energy_per_serving_kcal})">Select</button>
    `;
    document.getElementById('recipeDetails').innerHTML = recipeDetails;  // Display recipe details
}

async function selectRecipe(calories) {
    const username = JSON.parse(localStorage.getItem('userData')).username;

    try {
        const response = await fetch('http://127.0.0.1:5000/api/select_meal', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ username, recipe_name: localStorage.getItem('selectedRecipe') }),
        });

        const data = await response.json();
        alert(data.message || `Remaining Calories: ${data.remaining_calories} kcal`);

        if (data.remaining_calories <= 0) {
            alert("Congratulations! You've achieved your daily calorie goal.");
            window.location.href = 'dashboard.html';  // Redirect to dashboard if goal is achieved
        }
    } catch (error) {
        console.error('Error selecting recipe:', error);
    }
}
