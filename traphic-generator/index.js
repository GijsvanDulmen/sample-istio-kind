const request = require('request');

setInterval(() => {
    const base = "http://localhost";

    const list = ["rocksolid", "normal", "needhelp", "mirror", "delay", "abort", "canary"];

    list.forEach(i => {
        const url = base + "/" + i;
        console.log("> calling " + url);
        request(url, (err, response, body) => {
            if ( err ) {
                console.log(err);
            } else {
                console.log("< response " + response.statusCode);
            }
        });
    })

}, 300);