const { Booking, Arena } = require('../models');
const { Op } = require('sequelize');

// Create booking with conflict check
exports.createBooking = async (req, res) => {
  try {
    const { arena_id, date, start_time, end_time } = req.body;
    const arena = await Arena.findByPk(arena_id);
    if (!arena) return res.status(404).json({ message: 'Arena not found' });

    // Check overlapping bookings on same arena, date
    const overlapping = await Booking.findOne({
      where: {
        arena_id,
        date,
        status: { [Op.ne]: 'cancelled' },
        [Op.or]: [
          { start_time: { [Op.between]: [start_time, end_time] } },
          { end_time: { [Op.between]: [start_time, end_time] } },
          {
            [Op.and]: [
              { start_time: { [Op.lte]: start_time } },
              { end_time: { [Op.gte]: end_time } }
            ]
          }
        ]
      }
    });

    if (overlapping) {
      return res.status(409).json({ message: 'Time slot already booked' });
    }

    const booking = await Booking.create({
      user_id: req.user.id,
      arena_id,
      date,
      start_time,
      end_time,
      status: 'confirmed'
    });
    res.status(201).json(booking);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get user's own bookings
exports.getUserBookings = async (req, res) => {
  try {
    const bookings = await Booking.findAll({
      where: { user_id: req.user.id },
      include: ['arena']
    });
    res.json(bookings);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Owner: get bookings for all arenas owned by current user
exports.getOwnerBookings = async (req, res) => {
  try {
    const arenas = await Arena.findAll({ where: { owner_id: req.user.id }, attributes: ['id'] });
    const arenaIds = arenas.map(a => a.id);
    const bookings = await Booking.findAll({
      where: { arena_id: arenaIds },
      include: ['arena', 'user']
    });
    res.json(bookings);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};