const express = require('express');
const dotenv = require('dotenv');
const pool = require('./db'); 
const userRoutes = require('./routes/userRoutes'); // Ensure correct path


dotenv.config(); 

const app = express();
app.use(express.json()); 
app.use('/api', userRoutes);


app.get('/', (req, res) => {
    res.send('IIAEMS Backend Running...');
});

const PORT = process.env.PORT || 5000;
console.log("Available routes:");
console.log(app._router.stack);

app._router.stack.forEach((layer) => {
    if (layer.route) {
        console.log(`✅ Route registered: ${layer.route.path}`);
    } else if (layer.name === 'router' && layer.handle.stack) {
        layer.handle.stack.forEach((subLayer) => {
            if (subLayer.route) {
                console.log(`✅ Sub-route registered: ${subLayer.route.path}`);
            }
        });
    }
});

app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

pool.connect()
    .then(() => console.log('✅ Connected to PostgreSQL'))
    .catch(err => console.error('❌ Database connection error:', err));
