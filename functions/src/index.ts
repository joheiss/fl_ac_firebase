import { firestore } from 'firebase-functions';
import * as admin from 'firebase-admin';

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

admin.initializeApp();

export const handleMessageCreate = firestore
    .document('chats/4n5emtMyDM6knvL2UGGM/messages/{message}')
    .onCreate(async (change, context) => {
        const ref = await admin.firestore().collection('users').doc(change.data().userId).get();
        const username = ref?.data()?.username ?? change.data().userId;
        return admin.messaging().sendToTopic('ac_firebase', {
            notification: {
                title: username,
                body: change.data().text,
                clickAction: 'FLUTTER_NOTIFICATION_STRING'
            }
        });
    });
