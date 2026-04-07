const express = require('express');
const { getAllArenas, getArenaById, getArenaSchedule, createArena, updateArena, deleteArena, getMyArenas } = require('../controllers/arenaController');
const auth = require('../middleware/authMiddleware');
const role = require('../middleware/roleMiddleware');
const router = express.Router();

// Public
router.get('/', getAllArenas);
router.get('/:id', getArenaById);
router.get('/:id/schedule', getArenaSchedule);

// Owner routes
router.post('/owner/arenas', auth, role('owner', 'admin'), createArena);
router.get('/owner/arenas', auth, role('owner', 'admin'), getMyArenas);
router.put('/owner/arenas/:id', auth, role('owner', 'admin'), updateArena);
router.delete('/owner/arenas/:id', auth, role('owner', 'admin'), deleteArena);

module.exports = router;