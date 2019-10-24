'use strict';

// ------------------------------------------------------------------
// APP INITIALIZATION
// ------------------------------------------------------------------

const { App } = require('jovo-framework');
const { Alexa } = require('jovo-platform-alexa');
const { GoogleAssistant } = require('jovo-platform-googleassistant');
const { JovoDebugger } = require('jovo-plugin-debugger');
const { Firestore } = require('jovo-db-firestore');

const admin = require('firebase-admin');
admin.initializeApp();

let db = admin.firestore();

const app = new App();

app.use(
  new Alexa(),
  new GoogleAssistant(),
  new JovoDebugger(),
  new Firestore({}, db)
);

// ------------------------------------------------------------------
// APP LOGIC
// ------------------------------------------------------------------

app.setHandler({
  LAUNCH() {
    if (this.$user.$data.recordKey) {
      this.tell('I already have your record key.');
    } else {
      this.$speech.addText(
        'Hello! I can help you keep track of your eye patching time. Do you have a record key to get started?'
      );
      this.$reprompt.addText(
        'A record key is a 16 digit number that is used to keep track of your eye patching time. It is available on the Patch Me app on your android or iOS device. Do you have it handy?'
      );

      this.followUpState('CaptureRecordKeyPrefixState').ask(
        this.$speech,
        this.$reprompt
      );
    }
  },
  CaptureRecordKeyPrefixState: {
    YesIntent() {
      this.$speech.addText(
        'Great! What are the first 8 digits of your record key.'
      );
      this.$reprompt.addText(
        "I didn't quite catch that. Can you please repeat the first 8 digits of your record key."
      );
      this.ask(this.$speech, this.$reprompt);
    },
    NoIntent() {
      this.tell(
        'No problem. It is simple to get or create a new record key. Just download and open the Patch Me app on your android or iOS device to get started.'
      );
    },
    async CaptureRecordKeyPrefixIntent() {
      if (this.$inputs.RecordKeyPrefix.value.length != 8) {
        this.ask(
          "That doesn't seem to be 8 digits. Can you please repeat the first 8 digits of your record key."
        );
      } else {
        const recordKeyPrefix =
          this.$inputs.RecordKeyPrefix.value.substring(0, 4) +
          '-' +
          this.$inputs.RecordKeyPrefix.value.substring(4, 8);

        console.log(`~~~~ Record Key Prefix: ${recordKeyPrefix}`);
        var speak =
          'I was not able to find any record keys that start with those numbers. Can you please repeat the first 8 digits of your record key.';
        var reprompt = speak;

        var snapshot = await db.collection('users').get();
        for (let doc of snapshot.docs) {
          console.log(`~~~~ Checking against: ${doc.id}`);
          if (doc.id.startsWith(recordKeyPrefix)) {
            this.$user.$data.recordKey = doc.id;
            speak = `Thanks, I'll remember that. \
                    Now you can say start patching timer, stop patching timer, or ask me how many minutes of patching time is still remaining for today. \
                    I can also give you a report for the last 30 days. What would you like to do next?`;
            reprompt = `you can ask me to start patching timer, stop patching timer, or ask me how many minutes of patching is still remaining for today`;
            this.removeState();
            break;
          }
        }

        this.ask(speak, reprompt);
      }
    }
  },
  Unhandled() {
    // intent will be caught here
    this.tell(`you just triggered ${this.$request.getIntentName()}`);
  },
  ON_ERROR() {
    console.log(`Error: ${JSON.stringify(this.$alexaSkill.getError())}`);
    console.log(`Request: ${JSON.stringify(this.$alexaSkill.$request)}`);

    this.ask(
      'Sorry, I had trouble doing what you asked. Can I help you in any other way?'
    );
  },
  END() {
    this.tell('Goodbye!');
  },
  HelpIntent() {
    this.tell(
      `you can ask me to start patching timer, stop patching timer, or ask me how many minutes of patching is still remaining for the day. \
        I can also give you a report of your patching for the last 30 days.`
    );
  }
});

module.exports.app = app;
