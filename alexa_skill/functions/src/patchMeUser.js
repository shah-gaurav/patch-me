const admin = require('firebase-admin');
admin.initializeApp();

let db = admin.firestore();

async function getRecordKeyFromPrefix(recordKeyPrefix) {
  const formattedRecordKeyPrefix =
    recordKeyPrefix.substring(0, 4) + '-' + recordKeyPrefix.substring(4, 8);

  console.log(`~~~~ Record Key Prefix: ${formattedRecordKeyPrefix}`);
  var snapshot = await db.collection('users').get();
  for (let doc of snapshot.docs) {
    console.log(`~~~~ Checking against: ${doc.id}`);
    if (doc.id.startsWith(formattedRecordKeyPrefix)) {
      return doc.id;
    }
  }
  return null;
}

module.exports.GetRecordKeyFromPrefix = getRecordKeyFromPrefix;
module.exports.DB = db;
