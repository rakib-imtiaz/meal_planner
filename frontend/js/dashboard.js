// /js/dashboard.js
document.addEventListener('DOMContentLoaded', () => {
    const userData = JSON.parse(localStorage.getItem('userData'));
    if (userData) {
        document.getElementById('userInfo').innerHTML = `
            <p>Name: ${userData.name}</p>
            <p>Daily Calories: ${userData.daily_calories} kcal</p>
            <p>Remaining Calories: ${userData.remaining_calories} kcal</p>
        `;
    } else {
        alert('No user data found. Please log in.');
        window.location.href = 'login.html';
    }
});
