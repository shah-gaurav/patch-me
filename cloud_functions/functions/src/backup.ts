import * as functions from 'firebase-functions';

import * as admin from 'firebase-admin';

const db = admin.firestore();

export const createBackup = functions.firestore.document('users/{userId}')
    .onUpdate(async (change, context) => {
        const userId = context.params.userId;
        console.log(`Document ${userId} was updated.`);

        const previousValue = change.before.data();
        const backupCollectionName = `backups_${new Date().getMonth()}_${new Date().getFullYear()}`;
        if (previousValue) {
            const backupDocumentId = `${userId}_${(new Date()).getTime()}`;
            await db.collection(backupCollectionName).doc(backupDocumentId).set(previousValue);
            console.log(`Document ${userId} was backed up as ${backupDocumentId}.`);
        }
    });