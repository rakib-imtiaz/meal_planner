// /js/signup.js
document.getElementById('signupForm').addEventListener('submit', async (e) => {
    e.preventDefault();

    const sex = document.querySelector('input[name="sex"]:checked').value;  // Get selected sex value
    const formData = {
        username: document.getElementById('username').value,
        password: document.getElementById('password').value,
        name: document.getElementById('name').value,
        age: parseInt(document.getElementById('age').value),
        sex: sex,  // Capture selected sex value
        weight: parseFloat(document.getElementById('weight').value),
        height: parseFloat(document.getElementById('height').value),  // Allow fractional height
        goal: document.getElementById('goal').value,
        is_vegan: document.getElementById('is_vegan').checked
    };

    const response = await fetch('http://127.0.0.1:5000/api/signup', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData),
    });

    const data = await response.json();
    alert(data.message);
    if (response.ok) {
        window.location.href = 'login.html';
    }
});
