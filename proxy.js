const express = require("express");
const axios = require("axios");

const app = express();

const apiUrl = "https://timeapi.io/api/Time/current/zone";
const availableTimeZonesUrl =
  "https://timeapi.io/api/TimeZone/AvailableTimeZones";

app.use((req, res) => {
  const requestedUrl = req.path;

  if (requestedUrl === "/api/time") {
    const timeZone = req.query.timeZone;

    if (!timeZone) {
      res.status(400).json({ error: "Missing timeZone query parameter" });
      return;
    }

    const url = `${apiUrl}?timeZone=${encodeURIComponent(timeZone)}`;

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
    axios
      .get(url)
      .then((response) => {
        res.send(response.data);
      })
      .catch((error) => {
        console.error(error);
        res.status(500).json({ error: "Internal Server Error" });
      });
  } else if (requestedUrl === "/api/timezone") {
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

    // Proxy the request to the available time zones URL
    axios
      .get(availableTimeZonesUrl)
      .then((response) => {
        res.send(response.data);
      })
      .catch((error) => {
        console.error(error);
        res.status(500).json({ error: "Internal Server Error" });
      });
  } else {
    res.status(400).json({ error: "Invalid URL" });
  }
});

app.listen(3000, () => {
  console.log("Proxy server listening on port 3000");
});
