'use strict';
// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');

const { Webhook, ExpressJS, GoogleCloudFunction } = require('jovo-framework');
const { app } = require('./app.js');

// ------------------------------------------------------------------
// HOST CONFIGURATION
// ------------------------------------------------------------------

// ExpressJS (Jovo Webhook)
if (process.argv.indexOf('--webhook') > -1) {
  const port = process.env.JOVO_PORT || 3000;
  Webhook.jovoApp = app;

  Webhook.listen(port, () => {
    console.info(`Local server listening on port ${port}.`);
  });

  Webhook.post('/webhook', async (req, res) => {
    await app.handle(new ExpressJS(req, res));
  });
}

exports.alexaSkill = functions.https.onRequest(async (req, res) => {
  await app.handle(new GoogleCloudFunction(req, res));
});
