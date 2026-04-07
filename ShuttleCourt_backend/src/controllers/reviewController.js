const { Review, Arena } = require('../models');

exports.createReview = async (req, res) => {
  try {
    const { arena_id, rating, comment } = req.body;
    const arena = await Arena.findByPk(arena_id);
    if (!arena) return res.status(404).json({ message: 'Arena not found' });
    
    const review = await Review.create({
      user_id: req.user.id,
      arena_id,
      rating,
      comment
    });
    res.status(201).json(review);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.getArenaReviews = async (req, res) => {
  try {
    const reviews = await Review.findAll({
      where: { arena_id: req.params.arenaId },
      include: [{ association: 'user', attributes: ['id', 'name'] }],
      order: [['createdAt', 'DESC']]
    });
    res.json(reviews);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};