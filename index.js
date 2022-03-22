const express = require("express");
const app = express();
const fs = require("fs");
const cors = require("cors");
var bodyParser = require("body-parser");
var jsonParser = bodyParser.json();

// enable cors, serve files from /video
app.use(cors());
app.use("/video", express.static(__dirname + "/video"));

var latencies = [];
var resolutions = [];

app.get("/client/:clientId/latency/:latency", (req, res) => {
  req.params;
  latencies.push(parseFloat(req.params.latency));
  res.json(req.params);
});

app.get("/latencies", (req, res) => {
  const sum = latencies.reduce((a, b) => a + b, 0);
  const avg = sum / latencies.length || 0;
  res.json(avg);
});

app.post("/resolution", jsonParser, (req, res) => {
  console.log(req.body);
  resolutions.push(req.body);
  res.json(req.body);
});

app.get("/resolutions", (req, res) => {
  res.json(resolutions);
});

app.listen(8000, function () {
  console.log("Listening on port 8000!");
});
