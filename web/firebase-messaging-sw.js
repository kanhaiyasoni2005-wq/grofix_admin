importScripts(
  "https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js"
);

importScripts(
  "https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js"
);

firebase.initializeApp({
  apiKey: 'AIzaSyDaSJmMz6UELjm2PcbXZJRbMkbd-V4413c',
  authDomain: 'whatsapp-97b8c.firebaseapp.com',
  projectId: 'whatsapp-97b8c',
  storageBucket: 'whatsapp-97b8c.firebasestorage.app',
  messagingSenderId: '717672718438',
  appId: '1:717672718438:android:6c4530ca32782d015ecda7',
});

const messaging = firebase.messaging();