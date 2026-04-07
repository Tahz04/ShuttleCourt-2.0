const express = require('express');
const { createBooking, getUserBookings, getOwnerBookings } = require('../controllers/bookingController');
const auth = require('../middleware/authMiddleware');
const role = require('../middleware/roleMiddleware');
const router = express.Router();

router.post('/', auth, createBooking);
router.get('/user', auth, getUserBookings);
router.get('/owner/bookings', auth, role('owner', 'admin'), getOwnerBookings);

module.exports = router;