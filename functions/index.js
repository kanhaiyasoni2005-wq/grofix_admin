const admin = require("firebase-admin");
const { onDocumentCreated } = require("firebase-functions/v2/firestore");

admin.initializeApp();

exports.sendOrderNotification = onDocumentCreated(
  "orders/{orderId}",
  async (event) => {
    try {

      const orderId = event.params.orderId; // ✅ safe extract

      const db = admin.firestore();

      const adminDoc = await db
        .collection("admin")
        .doc("settings")
        .get();

      if (!adminDoc.exists) {
        console.log("Admin token not found");
        return;
      }

      const token = adminDoc.data().token;

      await admin.messaging().send({
        token: token,
        notification: {
          title: "🛒 New Order",
          body: `Order ID: ${orderId}`,
        },
        android: {
          priority: "high",
          notification: {
            sound: "default",
          },
        },
      });

      console.log("Notification sent");

    } catch (e) {
      console.error("ERROR:", e);
    }
  }
);

const { onDocumentUpdated } =
require("firebase-functions/v2/firestore");

exports.sendUserStatusNotification =
onDocumentUpdated(
"orders/{orderId}",

async (event) => {

try {

const before =
event.data.before.data();

const after =
event.data.after.data();

if (
before.status ===
after.status
) {
return;
}

const userId =
after.userId;

if (!userId) {
return;
}

const db =
admin.firestore();

const userDoc =
await db
.collection("users")
.doc(userId)
.get();

if (!userDoc.exists) {
return;
}

const token =
userDoc.data().fcmToken;

if (!token) {
return;
}

await admin.messaging().send({

token: token,

notification: {

title:
"Order Update",

body:
`Status: ${after.status}`,

},

android: {

priority:
"high",

notification: {
sound:
"default",
},

},

});

console.log(
"User notification sent"
);

} catch (e) {

console.error(e);

}

});