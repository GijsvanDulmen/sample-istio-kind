const proxy = require('express-http-proxy');
const express = require('express');
const app = express();
const morgan = require('morgan')
const request = require('request');

const client = require('prom-client');
client.collectDefaultMetrics();

app.use(morgan('combined'));
app.get('/live', (req, res) => res.send("OK"));
app.get('/ready', (req, res) => res.send("OK"));

app.get('/metrics', (request, response) => {
  response.set('Content-Type', client.register.contentType);
  response.send(client.register.metrics());
});

if ( process.env.PROXY_TO != undefined ) {
    console.log("Proxy to " + process.env.PROXY_TO);
    app.use('/', proxy(process.env.PROXY_TO, {
        proxyErrorHandler: function(err, res, next) {
            console.log(err);
            next(err);
        }
    }));
}

if ( process.env.GO_TO != undefined ) {
    console.log("Go to " + process.env.GO_TO);
    app.all('/*', (req, res) => {
        request(process.env.GO_TO, (err, response, body) => {
            res.send(body);
        });
        // res.status(parseInt(statusCode)).send(contents);
    });
}

app.listen(8081, () => console.log(`Repeat server listening`))