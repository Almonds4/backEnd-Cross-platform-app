const express = require('express');
const pool = require('../db'); // Import database connection
const bcrypt = require('bcryptjs');

const router = express.Router();

// Debugging: Check if this file is being loaded
console.log("✅ userRoutes.js loaded");

// Route to register a new user
router.post('/users', async (req, res) => {
    try {
        const { name, email, password } = req.body;

        // Debugging: Check if request reaches here
        console.log("➡️ Received POST request to /users");

        // Hash the password before storing it
        const hashedPassword = await bcrypt.hash(password, 10);

        const newUser = await pool.query(
            "INSERT INTO users (name, email, password) VALUES ($1, $2, $3) RETURNING *",
            [name, email, hashedPassword]
        );

        res.json(newUser.rows[0]); // Return the created user
    } catch (err) {
        console.error(err);
        res.status(500).send("Server Error");
    }
});

module.exports = router;
