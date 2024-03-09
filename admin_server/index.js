const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const router = require('./router/index')
const app = express();
const PORT = process.env.PORT || 3001;

app.use(bodyParser.json());
app.use(cors());

app.use('/api', router);

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});