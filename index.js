const express = require("express");
const app = express();
const fs = require("fs");
const cors = require("cors");

// enable cors, serve files from /video
app.use(cors());
app.use("/video", express.static(__dirname + "/video"));

app.listen(8000, function () {
  console.log("Listening on port 8000!");
});
