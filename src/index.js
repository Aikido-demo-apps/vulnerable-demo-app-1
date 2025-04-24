const path = require('path');
import express from "express";

const app = express();

app.get("/", (req, res) => {
    console.log('blib');
  res.send("Hello World!");
});

app.get("/redirect", (req, res) => {
  res.redirect(`http://${req.hostname}:3000${req.url}`);
});

app.get("/error", (req, res) => {
  throw new Error("Something broke!");
});

app.get("/payments", (req, res) => {
  const STRIPE_API_KEY = "sk_live_fakestripeapikeyleaked12"
  res.status(200).send(STRIPE_API_KEY)
});

const getFileName = (req) => path.join('tmp', req.params.name);

app.get('/file/:name', function (req, res, next) {
  const fileName = getFileName(req);
  res.sendFile(fileName);
});

app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).send("Something broke!", err);
});

app.listen(3000, () => {
  console.log("Server running on port 3000");
});
