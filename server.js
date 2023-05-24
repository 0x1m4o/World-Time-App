const express = require("express");
const request = require("request");

const app = express();

const allowedUrls = {
  "/api/time": "https://timeapi.io/api/Time/current/zone?timeZone=Asia/Jakarta",
  "/api/timezone": "https://timeapi.io/api/TimeZone/AvailableTimeZones",
};

app.use((req, res) => {
  const requestedUrl = req.path;

  if (!allowedUrls.hasOwnProperty(requestedUrl)) {
    res.status(400).json({ error: "Invalid URL" });
    return;
  }

  const url = allowedUrls[requestedUrl];

  // Set the necessary CORS headers
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader(
    "Access-Control-Allow-Methods",
    "GET,OPTIONS,PATCH,DELETE,POST,PUT"
  );
  res.setHeader(
    "Access-Control-Allow-Headers",
    "X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version"
  );

  // Proxy the request to the requested URL
  req.pipe(request(url)).pipe(res);
});

app.listen(3000, () => {
  console.log("Proxy server listening on port 3000");
});
