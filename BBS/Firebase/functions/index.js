/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const { onRequest } = require("firebase-functions/v2/https")
const { onCall } = require("firebase-functions/v2/https")

const functions = require('firebase-functions/v1');
const admin = require("firebase-admin")
const logger = require("firebase-functions/logger")

admin.initializeApp()

const { FieldValue } = require('firebase-admin/firestore');

// HTTPS Callable 함수: 기존 관리자가 다른 사용자에게 관리자 역할 부여
exports.addAdminRole = onCall(
	{
		// v2에서는 콜러블 함수의 옵션을 여기서 설정할 수 있습니다
		minInstances: 0,
		maxInstances: 10,
	},
	async (request) => {
		const data = request.data
		const auth = request.auth

		// 요청자가 관리자인지 먼저 확인 (중요!)
		// auth가 없거나 관리자 클레임이 없으면 에러 반환
		if (!auth || !auth.token.admin) {
			throw new Error(
				"permission-denied: Must be an administrative user to initiate admin role assignment."
			)
		}

		const email = data.email // 관리자로 지정할 사용자의 이메일
		if (!email) {
			throw new Error("invalid-argument: Email is required.")
		}

		try {
			const user = await admin.auth().getUserByEmail(email)
			await admin.auth().setCustomUserClaims(user.uid, { admin: true })
			return { message: `Success! ${email} has been made an admin.` }
		} catch (error) {
			console.error("Error setting custom claims:", error)
			throw new Error("internal: Error assigning admin role.")
		}
	}
)

// Auth onCreate 트리거: 특정 이메일 주소로 가입 시 자동으로 관리자 역할 부여 (v1 문법 사용)
exports.assignAdminOnCreate = functions.region("asia-northeast3").auth.user().onCreate((user) => {
	// 비동기 함수를, 프로미스 리턴으로 변경
	if (user.email === "jmbae@codegrove.co.kr") {
		return admin
			.auth()
			.setCustomUserClaims(user.uid, { admin: true })
			.then(() => {
				console.log(`Admin role automatically assigned to ${user.email}`)
				return null
			})
			.catch((error) => {
				console.error("Error auto-assigning admin role:", error)
				return null
			})
	}
	return null // 조건에 맞지 않으면 바로 null 반환
})


// posts/{postId}/comments/{commentId} 문서가 생성되면 posts/{postId} 문서에 댓글 수 증가
// posts/{postId}/comments/{commentId} 문서가 deleted 상태가 되면 posts/{postId} 문서에 댓글 수 감소
// TTL 설정으로 30일 후 자동 삭제
exports.updateCommentCount = functions
  .region("asia-northeast3")
  .firestore.document("posts/{postId}/comments/{commentId}")
  .onWrite(async (change, context) => {
    const postId = context.params.postId
    const postRef = admin.firestore().collection("posts").doc(postId)

    if (!change.after.exists) {
      // 댓글이 삭제된 경우
      logger.log("Comment deleted")
      await postRef.update({
        commentsCount: FieldValue.increment(-1),
      })
      return null
    }

    if (!change.before.exists) {
      // 댓글이 생성된 경우
      logger.log("Comment created")
      await postRef.update({
        commentsCount: FieldValue.increment(1),
      })
      return null
    }
  })