// console.log('Debug: profile.js file loaded');

// document.addEventListener('DOMContentLoaded', function() {
//     console.log('Debug: DOMContentLoaded event fired in profile.js');

//     const form = document.getElementById('profileForm');
//     const generateButton = document.getElementById('generateButton');
//     console.log('Debug: Generate button element in profile.js:', generateButton);

//     if (generateButton) {
//         generateButton.addEventListener('click', function(e) {
//             console.log('Debug: Generate button clicked in profile.js');
//             e.preventDefault();

//             const formData = new FormData(form);

//             fetch('/profile', {
//                 method: 'POST',
//                 body: formData
//             })
//             .then(response => response.json())
//             .then(data => {
//                 console.log('Debug: Received data:', data);
//                 updateBMI(data.bmi);
//                 updateCalories(data.calories);
//                 updateMealRecommendations(data.meals);
//                 updateCalorieComparison(data.calorie_comparison);
//                 updateNutritionalValues(data.nutritional_values);
//             })
//             .catch(error => console.error('Debug: Error:', error));
//         });
//     } else {
//         console.error('Debug: Generate button not found in profile.js');
//     }

//     function updateBMI(bmi) {
//         const bmiResult = document.getElementById('bmi_result');
//         const bmiCategory = document.getElementById('bmi_category');
//         if (bmiResult && bmiCategory) {
//             bmiResult.textContent = `BMI: ${bmi.value.toFixed(2)} kg/m²`;
//             bmiCategory.textContent = bmi.category;
//         }
//     }

//     function updateCalories(calories) {
//         const calorieResults = document.getElementById('calorie_results');
//         if (calorieResults) {
//             calorieResults.innerHTML = '';
//             for (const [level, value] of Object.entries(calories)) {
//                 const div = document.createElement('div');
//                 div.textContent = `${level}: ${value} Calories`;
//                 calorieResults.appendChild(div);
//             }
//         }
//     }

//     function updateMealRecommendations(meals) {
//         const mealSelects = {
//             breakfast: document.getElementById('breakfast_select'),
//             lunch: document.getElementById('lunch_select'),
//             dinner: document.getElementById('dinner_select')
//         };

//         for (const [meal, options] of Object.entries(meals)) {
//             const select = mealSelects[meal];
//             if (select) {
//                 select.innerHTML = '';
//                 options.forEach(option => {
//                     const optionElement = document.createElement('option');
//                     optionElement.value = option;
//                     optionElement.textContent = option;
//                     select.appendChild(optionElement);
//                 });
//             }
//         }
//     }

//     function updateCalorieComparison(data) {
//         const ctx = document.getElementById('calorie_chart');
//         if (ctx) {
//             new Chart(ctx, {
//                 type: 'bar',
//                 data: {
//                     labels: ['Total Calories', 'Goal Calories'],
//                     datasets: [{
//                         label: 'Calories',
//                         data: [data.total, data.goal],
//                         backgroundColor: ['#4CAF50', '#2196F3']
//                     }]
//                 },
//                 options: {
//                     scales: {
//                         y: {
//                             beginAtZero: true
//                         }
//                     }
//                 }
//             });
//         }
//     }

//     function updateNutritionalValues(data) {
//         const ctx = document.getElementById('nutrition_chart');
//         if (ctx) {
//             new Chart(ctx, {
//                 type: 'doughnut',
//                 data: {
//                     labels: Object.keys(data),
//                     datasets: [{
//                         data: Object.values(data),
//                         backgroundColor: [
//                             '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40'
//                         ]
//                     }]
//                 }
//             });
//         }
//     }
// });
