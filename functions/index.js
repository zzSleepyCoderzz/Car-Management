const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendWelcomeNotification = functions.auth.user().onCreate((user) => {
    const payload = {
        notification: {
            title: 'Welcome!',
            body: `Welcome ${user.displayName || 'New User'}!`
        }
    };

    // Assuming you have the device token for push notifications stored in Firestore
    return admin.firestore().collection('userTokens').doc(user.uid).get()
        .then(doc => {
            if (!doc.exists) {
                console.log('No device token found for user:', user.uid);
                return;
            }
            const token = doc.data().token;
            return admin.messaging().sendToDevice(token, payload);
        })
        .catch(error => {
            console.error('Error sending notification:', error);
        });
});
