const express = require('express');
const bodyParser = require('body-parser');

const app = express();
const port = 3000;

app.use(bodyParser.json());

app.get('/', (req, res) => {
    res.send('Real Estate Booking Backend');
});

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
const mongoose = require('mongoose');

mongoose.connect('mongodb://localhost:27017/realestate', { useNewUrlParser: true, useUnifiedTopology: true });

const UserSchema = new mongoose.Schema({
    username: String,
    email: String,
    // other user-related fields
});

const PropertySchema = new mongoose.Schema({
    id: Number,
    owner: String,
    description: String,
    ipfsHash: String,
    price: Number,
    isListed: Boolean
});

const User = mongoose.model('User', UserSchema);
const Property = mongoose.model('Property', PropertySchema);
