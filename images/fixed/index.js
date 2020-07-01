const express = require('express');
const app = express();
const morgan = require('morgan')

app.use(morgan('combined'));
app.get('/live', (req, res) => res.send("OK"));
app.get('/ready', (req, res) => res.send("OK"));

app.all('/*', (req, res) => {
    const statusCode = process.env.STATUS_CODE ? process.env.STATUS_CODE : "500";
    const contents = process.env.CONTENTS ? process.env.CONTENTS : 'PROBLEMS!';
    
    res.status(parseInt(statusCode)).send(contents);
});

app.listen(8082, () => console.log(`Fixed response server listening`))