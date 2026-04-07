const express = require('express');
const { getAllUsers, deleteUser, getAllArenas, deleteArena } = require('../controllers/adminController');
const auth = require('../middleware/authMiddleware');
const role = require('../middleware/roleMiddleware');
const router = express.Router();

router.use(auth, role('admin'));
router.get('/users', getAllUsers);
router.delete('/users/:id', deleteUser);
router.get('/arenas', getAllArenas);
router.delete('/arenas/:id', deleteArena);

module.exports = router;