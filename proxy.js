const axios = require("axios");

module.exports = async (req, res) => {
  const { timeZone } = req.query;
  const apiUrl = `https://timeapi.io/api/Time/current/zone?timeZone=${encodeURIComponent(
    timeZone
  )}`;
  const availableTimeZonesUrl =
    "https://timeapi.io/api/TimeZone/AvailableTimeZones";

  try {
    let response;

    if (req.url.includes("/api/time")) {
      response = await axios.get(apiUrl);
    } else if (req.url.includes("/api/timezone")) {
      response = await axios.get(availableTimeZonesUrl);
    } else {
      // Invalid URL
      res.status(400).json({ error: "Invalid URL" });
      return;
    }

    // Forward the response from the API server to the client
    res.status(response.status).json(response.data);
  } catch (error) {
    // Handle errors
    res.status(500).json({ error: "Internal Server Error" });
  }
};
