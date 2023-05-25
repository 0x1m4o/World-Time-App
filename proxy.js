const express = require("express");
const axios = require("axios");

const app = express();

const apiUrl = "https://timeapi.io/api/Time/current/zone";
const availableTimeZonesUrl =
  "https://timeapi.io/api/TimeZone/AvailableTimeZones";

app.get("/api/time", async (req, res) => {
  const { timeZone } = req.query;

  if (!timeZone) {
    res.status(400).json({ error: "Missing timeZone query parameter" });
    return;
  }

  const url = `${apiUrl}?timeZone=${encodeURIComponent(timeZone)}`;

  try {
    const response = await axios.get(url);
    res.send(response.data);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

app.get("/api/timezone", async (req, res) => {
  try {
    const response = await axios.get(availableTimeZonesUrl);
    res.send(response.data);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Proxy server listening on port ${port}`);
});
