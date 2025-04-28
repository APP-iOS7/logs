/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const { onCall } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
const logger = require("firebase-functions/logger");

admin.initializeApp();

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

exports.helloWorld = onRequest((request, response) => {
  logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});


// HTTPS Callable 함수: 기존 관리자가 다른 사용자에게 관리자 역할 부여
exports.addAdminRole = onCall({
  // v2에서는 콜러블 함수의 옵션을 여기서 설정할 수 있습니다
  minInstances: 0,
  maxInstances: 10,
}, async (request) => {
  const data = request.data;
  const auth = request.auth;

  // 요청자가 관리자인지 먼저 확인 (중요!)
  // auth가 없거나 관리자 클레임이 없으면 에러 반환
  if (!auth || !auth.token.admin) {
    throw new Error(
      "permission-denied: Must be an administrative user to initiate admin role assignment."
    );
  }

  const email = data.email; // 관리자로 지정할 사용자의 이메일
  if (!email) {
    throw new Error(
      "invalid-argument: Email is required."
    );
  }

  try {
    const user = await admin.auth().getUserByEmail(email);
    await admin.auth().setCustomUserClaims(user.uid, { admin: true });
    return { message: `Success! ${email} has been made an admin.` };
  } catch (error) {
    console.error("Error setting custom claims:", error);
    throw new Error(
      "internal: Error assigning admin role."
    );
  }
});


exports.assignAdminOnCreate = functions.auth.user().onCreate(async (user) => {
  if (user.email === "jmbae@codegrove.co.kr") {
    try {
      await admin.auth().setCustomUserClaims(user.uid, { admin: true });
      console.log(`Admin role automatically assigned to ${user.email}`);
    } catch (error) {
      console.error("Error auto-assigning admin role:", error);
    }
  }
});