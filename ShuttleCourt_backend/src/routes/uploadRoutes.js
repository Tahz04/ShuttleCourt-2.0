const express = require('express');
const { uploadArenaImage } = require('../controllers/uploadController');
const auth = require('../middleware/authMiddleware');
const router = express.Router();

router.post('/upload', auth, uploadArenaImage);
module.exports = router;