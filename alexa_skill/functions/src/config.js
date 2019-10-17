// ------------------------------------------------------------------
// APP CONFIGURATION
// ------------------------------------------------------------------

module.exports = {
  logging: true,

  intentMap: {
    'AMAZON.CancelIntent': 'END',
    'AMAZON.StopIntent': 'END',
    'AMAZON.YesIntent': 'YesIntent',
    'AMAZON.NoIntent': 'NoIntent',
    'AMAZON.HelpIntent': 'HelpIntent'
  },

  db: {
    Firestore: { collectionName: 'alexa-users' }
  },

  user: {
    dataCaching: true,
    implicitSave: true,
    metaData: {
      enabled: true,
      lastUsedAt: true,
      sessionsCount: true,
      createdAt: true,
      requestHistorySize: 10,
      devices: true
    }
  }
};
