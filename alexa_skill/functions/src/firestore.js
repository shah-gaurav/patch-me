'use strict';
Object.defineProperty(exports, '__esModule', { value: true });
const jovo_core_1 = require('jovo-core');
const _get = require('lodash.get');
const _merge = require('lodash.merge');
class Firestore {
  constructor(db, config) {
    this.firestore = db;
    this.config = {
      collectionName: 'UserData'
    };
    this.needsWriteFileAccess = false;
    this.isCreating = false;
    if (config) {
      this.config = _merge(this.config, config);
    }
  }
  install(app) {
    if (_get(app.config, 'db.default')) {
      if (_get(app.config, 'db.default') === 'Firestore') {
        app.$db = this;
      }
    } else {
      app.$db = this;
    }
  }

  /**
   * Throws JovoError if collectionName, credential or databaseURL was not set inside config.js
   */
  errorHandling() {
    if (!this.config.collectionName) {
      throw new jovo_core_1.JovoError(
        `collectionName has to be set`,
        jovo_core_1.ErrorCode.ERR_PLUGIN,
        'jovo-db-firestore',
        undefined,
        'Add the collectionName to the Firestore object inside your config.js',
        'https://www.jovo.tech/docs/databases/firestore'
      );
    }
  }
  /**
   * Returns object for given primaryKey
   * @param {string} primaryKey
   * @return {Promise<object>}
   */
  async load(primaryKey) {
    this.errorHandling();
    const docRef = this.firestore
      .collection(this.config.collectionName)
      .doc(primaryKey);
    const doc = await docRef.get();
    return doc.data();
  }
  /**
   * Saves data as value for key (default: "userData") inside document (primary key)
   * @param {string} primaryKey
   * @param {string} key
   * @param {any} data
   */
  async save(primaryKey, key, data, updatedAt) {
    this.errorHandling();
    const userData = {
      [key]: data
    };
    if (updatedAt) {
      userData.updatedAt = updatedAt;
    }
    const docRef = this.firestore
      .collection(this.config.collectionName)
      .doc(primaryKey);
    await docRef.set(userData, { merge: true });
  }
  /**
   * Deletes document referred to by primaryKey
   * @param {string} primaryKey
   */
  async delete(primaryKey) {
    this.errorHandling();
    const docRef = this.firestore
      .collection(this.config.collectionName)
      .doc(primaryKey);
    await docRef.delete();
  }
}
exports.Firestore = Firestore;
//# sourceMappingURL=Firestore.js.map
