const express = require('express');
const app = express();
const morgan = require('morgan')
const fs = require('fs');

app.use(morgan('combined'));
app.get('/live', (req, res) => res.send("OK"));
app.get('/ready', (req, res) => res.send("OK"));

app.all('/*', (req, res) => {
    const statusCode = process.env.STATUS_CODE ? process.env.STATUS_CODE : "500";
    const contents = process.env.CONTENTS ? process.env.CONTENTS : 'PROBLEMS!';
    
    let str = fs.readFileSync('./template.html').toString();

    // headers
    str = str.replace('\$MSG', contents);
    str = str.replace('\$STATUS', statusCode);

    str = str.replace('\$COLOR', statusCode == "500" ? "#b30000" : "#009933");
    
    res.status(parseInt(statusCode)).send(str);
});

app.listen(8082, () => console.log(`Fixed response server listening`))