const express = require('express');
const userRouter = require('./routes/user')
const router = express.router();

router.use('/users', userRouter);

module.exports = router;