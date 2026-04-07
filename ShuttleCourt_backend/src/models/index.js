const { Sequelize } = require('sequelize');
const config = require('../config/database')[process.env.NODE_ENV || 'development'];

const sequelize = new Sequelize(config.database, config.username, config.password, {
  host: config.host,
  dialect: config.dialect,
  logging: false,
});

const User = require('./User')(sequelize);
const Arena = require('./Arena')(sequelize);
const Booking = require('./Booking')(sequelize);
const Review = require('./Review')(sequelize);

// Associations
User.hasMany(Arena, { foreignKey: 'owner_id', as: 'arenas' });
Arena.belongsTo(User, { foreignKey: 'owner_id', as: 'owner' });

User.hasMany(Booking, { foreignKey: 'user_id', as: 'bookings' });
Booking.belongsTo(User, { foreignKey: 'user_id', as: 'user' });

Arena.hasMany(Booking, { foreignKey: 'arena_id', as: 'bookings' });
Booking.belongsTo(Arena, { foreignKey: 'arena_id', as: 'arena' });

User.hasMany(Review, { foreignKey: 'user_id', as: 'reviews' });
Review.belongsTo(User, { foreignKey: 'user_id', as: 'user' });

Arena.hasMany(Review, { foreignKey: 'arena_id', as: 'reviews' });
Review.belongsTo(Arena, { foreignKey: 'arena_id', as: 'arena' });

module.exports = {
  sequelize,
  User,
  Arena,
  Booking,
  Review,
};