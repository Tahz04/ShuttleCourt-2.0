const upload = require('../services/uploadService');

exports.uploadArenaImage = (req, res) => {
  upload.single('image')(req, res, (err) => {
    if (err) return res.status(400).json({ message: err.message });
    if (!req.file) return res.status(400).json({ message: 'No file uploaded' });
    res.json({ imageUrl: req.file.path });
  });
};