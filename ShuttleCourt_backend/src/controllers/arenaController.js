const { Arena, Booking, sequelize } = require('../models');
const { Op } = require('sequelize');

// Public: get all arenas
exports.getAllArenas = async (req, res) => {
  try {
    const arenas = await Arena.findAll();
    res.json(arenas);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Public: get arena by id
exports.getArenaById = async (req, res) => {
  try {
    const arena = await Arena.findByPk(req.params.id);
    if (!arena) return res.status(404).json({ message: 'Arena not found' });
    res.json(arena);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get schedule: available time slots for a given date (default today)
exports.getArenaSchedule = async (req, res) => {
  try {
    const { id } = req.params;
    const { date } = req.query;
    const selectedDate = date || new Date().toISOString().slice(0,10);
    
    const arena = await Arena.findByPk(id);
    if (!arena) return res.status(404).json({ message: 'Arena not found' });

    // Define operating hours e.g., 06:00 - 22:00, slot 1 hour
    const startHour = 6;
    const endHour = 22;
    const slots = [];
    for (let hour = startHour; hour < endHour; hour++) {
      const start = `${hour.toString().padStart(2,'0')}:00:00`;
      const end = `${(hour+1).toString().padStart(2,'0')}:00:00`;
      slots.push({ start_time: start, end_time: end });
    }

    // Fetch bookings for that date
    const bookings = await Booking.findAll({
      where: {
        arena_id: id,
        date: selectedDate,
        status: { [Op.ne]: 'cancelled' }
      },
      attributes: ['start_time', 'end_time']
    });

    const availableSlots = slots.map(slot => {
      const isBooked = bookings.some(book => 
        book.start_time === slot.start_time && book.end_time === slot.end_time
      );
      return { ...slot, is_available: !isBooked };
    });

    res.json({ date: selectedDate, slots: availableSlots });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Owner: create arena
exports.createArena = async (req, res) => {
  try {
    const { name, location, description, price, image } = req.body;
    const arena = await Arena.create({
      name, location, description, price, image,
      owner_id: req.user.id
    });
    res.status(201).json(arena);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Owner: update own arena
exports.updateArena = async (req, res) => {
  try {
    const arena = await Arena.findOne({ where: { id: req.params.id, owner_id: req.user.id } });
    if (!arena) return res.status(404).json({ message: 'Arena not found or not yours' });
    await arena.update(req.body);
    res.json(arena);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Owner: delete own arena
exports.deleteArena = async (req, res) => {
  try {
    const arena = await Arena.findOne({ where: { id: req.params.id, owner_id: req.user.id } });
    if (!arena) return res.status(404).json({ message: 'Arena not found or not yours' });
    await arena.destroy();
    res.json({ message: 'Arena deleted' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Owner: get my arenas
exports.getMyArenas = async (req, res) => {
  try {
    const arenas = await Arena.findAll({ where: { owner_id: req.user.id } });
    res.json(arenas);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};