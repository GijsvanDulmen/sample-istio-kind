var http = require('http');

http.createServer(onRequest).listen(8084);

function onRequest(client_req, client_res) {
  console.log('serve: ' + client_req.url);

  if ( client_req.url == '/live' || client_req.url == '/ready' ) {
    client_res.writeHead(200, {'Content-Type': 'text/plain'});
    client_res.write('OK!');
    client_res.end();
    return;
  }

  var options = {
    hostname: process.env.PROXY_TO,
    port: process.env.PROXY_TO_PORT,
    path: client_req.url,
    method: client_req.method,
    headers: client_req.headers
  };

  console.log(options);

  var proxy = http.request(options, function (res) {
    client_res.writeHead(res.statusCode, res.headers)
    res.pipe(client_res, {
      end: true
    });
  });

  client_req.pipe(proxy, {
    end: true
  });
}