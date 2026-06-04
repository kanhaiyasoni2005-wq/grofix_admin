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