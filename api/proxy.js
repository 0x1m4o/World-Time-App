const express = require("express");
const axios = require("axios");

const app = express();

const apiUrl = "https://timeapi.io/api/Time/current/zone";
const availableTimeZonesUrl =
  "https://timeapi.io/api/TimeZone/AvailableTimeZones";

app.use((req, res, next) => {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader(
    "Access-Control-Allow-Methods",
    "GET,OPTIONS,PATCH,DELETE,POST,PUT"
  );
  res.setHeader(
    "Access-Control-Allow-Headers",
    "X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version"
  );
  next();
});

app.get("/api/time", (req, res) => {
  const { timeZone } = req.query;

  if (!timeZone) {
    res.status(400).json({ error: "Missing timeZone query parameter" });
    return;
  }

  const url = `${apiUrl}?timeZone=${encodeURIComponent(timeZone)}`;

  axios
    .get(url)
    .then((response) => {
      res.send(response.data);
    })
    .catch((error) => {
      console.error(error);
      res.status(500).json({ error: "Internal Server Error" });
    });
});

app.get("/api/timezone", (req, res) => {
  axios
    .get(availableTimeZonesUrl)
    .then((response) => {
      res.send(response.data);
    })
    .catch((error) => {
      console.error(error);
      res.status(500).json({ error: "Internal Server Error" });
    });
});

app.listen(3000, () => {
  console.log("Proxy server listening on port 3000");
});
