const express = require('express');
const app = express();
const os = require('os');
const fs = require('fs');
const morgan = require('morgan')

const client = require('prom-client');
client.collectDefaultMetrics();

app.use(morgan('combined'));
app.get('/live', (req, res) => res.send("OK"));
app.get('/ready', (req, res) => res.send("OK"));

app.get('/metrics', (request, response) => {
  response.set('Content-Type', client.register.contentType);
  response.send(client.register.metrics());
});

app.all('/*', (req, res) => {
    let str = fs.readFileSync('./template.html').toString();

    // headers
    let headers = '';
    Object.keys(req.headers).forEach(k => {
        headers += "<span class='header'>"+k+"</span>: <span class='headervalue'>" + req.headers[k] + "</span></br>";
    });
    str = str.replace('\$HEADERS', headers);

    // remote address
    str = str.replace('\$REMOTEADDR', req.connection.remoteAddress);
    str = str.replace('\$SOCKADDR', req.socket.remoteAddress);

    // host
    str = str.replace('\$HOST', os.hostname());
    str = str.replace('\$UPTIME', os.uptime());
    
    // call
    str = str.replace('\$CALL', req.method + " " + req.originalUrl);

    res.send(str);
});

app.listen(8080, () => console.log(`Echo server listening`))