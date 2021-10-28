const functions = require('firebase-functions');
const admin = require('firebase-admin')
admin.initializeApp();


exports.postResizeImage = functions.firestore.document('posts/{postId}').onCreate(async (snap, context) => {
  const postId = snap.id;
  const resizeName = snap.data().post_image_name;
  // post_image_500
  await admin.storage().bucket().file(`image/resize_images/${resizeName}_500x500`).getSignedUrl({action: 'read',expires: '12-31-3020'})
  .then(async (signedUrl) => {
    await admin.firestore().collection('posts').doc(postId).update({post_image_500: `${signedUrl}`})
  })
  .catch((error) => {});
  // post_image_1080
  await admin.storage().bucket().file(`image/resize_images/${resizeName}_1080x1080`).getSignedUrl({action: 'read',expires: '12-31-3020'})
  .then(async (signedUrl) => {
    await admin.firestore().collection('posts').doc(postId).update({post_image_1080: `${signedUrl}`})
  })
  .catch((error) => {});
});
