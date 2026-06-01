const admin = require("firebase-admin");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");

admin.initializeApp();

exports.sendOrderNotification = onDocumentCreated(
  "orders/{orderId}",
  async (event) => {
    try {
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
          title: "New Order",
          body: "A new order has arrived",
        },
      });

      console.log("Notification sent");
    } catch (e) {
      console.error(e);
    }
  },
);