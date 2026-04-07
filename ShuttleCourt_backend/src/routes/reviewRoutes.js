const express = require('express');
const { createReview, getArenaReviews } = require('../controllers/reviewController');
const auth = require('../middleware/authMiddleware');
const router = express.Router();

router.post('/', auth, createReview);
router.get('/:arenaId', getArenaReviews);

module.exports = router;