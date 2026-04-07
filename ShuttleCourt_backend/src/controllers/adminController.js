const { User, Arena, Review, Booking } = require('../models');

exports.getAllUsers = async (req, res) => {
  try {
    const users = await User.findAll({ attributes: { exclude: ['password'] } });
    res.json(users);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.deleteUser = async (req, res) => {
  try {
    const user = await User.findByPk(req.params.id);
    if (!user) return res.status(404).json({ message: 'User not found' });
    await user.destroy();
    res.json({ message: 'User deleted' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.getAllArenas = async (req, res) => {
  try {
    const arenas = await Arena.findAll({ include: ['owner'] });
    res.json(arenas);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.deleteArena = async (req, res) => {
  try {
    const arena = await Arena.findByPk(req.params.id);
    if (!arena) return res.status(404).json({ message: 'Arena not found' });
    await arena.destroy();
    res.json({ message: 'Arena deleted by admin' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};