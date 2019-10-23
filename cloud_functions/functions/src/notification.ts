import * as functions from 'firebase-functions';

import * as admin from 'firebase-admin';

const db = admin.firestore();

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

export const sendNotifications = functions.https.onRequest(async (request, response) => {
    const documents = await db.collection("users").where('timer-running', '==', true).get();
    for (const doc of documents.docs) {
        const data = doc.data();
        const timeRemaining = data['time-remaining'];
        const startTimeEpoch = data['start-time'];
        const startTime = new Date(startTimeEpoch);
        const timeElapsed = getMinutesBetweenDates(startTime, new Date());
        const difference = timeRemaining - timeElapsed;

        if (difference < 10) {
            let sendNotification = true;
            try {
                const notificationDoc = await db.collection("notifications").doc(doc.id).get();
                if (notificationDoc.exists) {
                    const notificationData = notificationDoc.data();
                    if (notificationData !== undefined) {
                        const lastNotificationSent = notificationData['last-notification-sent'];
                        const lastNotificationId = notificationData['last-notification-id'];
                        if (lastNotificationId === startTimeEpoch) {
                            console.log(`Notification already sent for id ${lastNotificationId}. Not sending another notification.`);
                            sendNotification = false;
                        }
                        else if (lastNotificationSent !== undefined) {
                            const dateLastNotificationSent = lastNotificationSent.toDate();
                            const timeSinceLastNotification = getMinutesBetweenDates(dateLastNotificationSent, new Date());
                            if (timeSinceLastNotification < 60) {
                                console.log(`It has only been ${timeSinceLastNotification} minutes since last notification. Not sending another notification.`);
                                sendNotification = false;
                            }
                        }
                    }
                }
            } catch (error) {
                console.log(error);
            }

            if (sendNotification) {
                // Listing all tokens as an array.
                const tokens = data['tokens'];
                console.log(`${doc.id} has tokens: ${tokens}`);

                if (tokens !== null && tokens.length !== 0) {

                    console.log(`${doc.id} has ${difference} minutes remaining. Sending notification.`);
                    // Notification details.
                    const payload = {
                        notification: {
                            title: 'Patch Me',
                            body: `Patching is almost complete, please check the app for more details.`
                        }
                    };

                    // Send notifications to all tokens.
                    try {
                        const fcmResponse = await admin.messaging().sendToDevice(tokens, payload);
                        console.log(`Successfully sent notification: ${fcmResponse}`);

                        await db.collection("notifications").doc(doc.id)
                            .set({
                                'last-notification-sent': admin.firestore.FieldValue.serverTimestamp(),
                                'last-notification-id': startTimeEpoch,
                            });
                    }
                    catch (error) {
                        console.log(`Error sending notification: ${error}`);
                    }
                }
            }
        }
    }
    response.status(200).send("success");
});

function getMinutesBetweenDates(startDate: Date, endDate: Date) {
    const diff = endDate.getTime() - startDate.getTime();
    return Math.floor(diff / 60000);
}
