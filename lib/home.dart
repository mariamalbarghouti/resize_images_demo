// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:kids_care_demo/constants.dart';
// import 'package:kids_care_demo/upload_isolate.dart';

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         floatingActionButton: FloatingActionButton.extended(
//           onPressed: () async  {
//             //PICK IMAGE FROM GALLERY
//             final image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
//             //CHECK IF IMAGE IS NULL OR NOT
//             if(image!=null){
//               //GIVE IMAGE TO OUR ISOLATE FUNCTION WHICH WILL MAKE A ISOLATE AND UPLOAD THIS IMAGE TO THAT ISOLATE
//               uploadImageToFirebase(image.path);
//             }
//           },
//           label: Text('Upload'),
//           icon: Icon(Icons.upload_outlined),
//         ),
//         body: ValueListenableBuilder(
//             valueListenable: isUploading,
//             builder: ( context, value, child) {
//               switch (value) {
//                 case UploadStatus.Idle:
//                   return Center(
//                       child: Text("Upload the file to Firebase Storage"));
//                 case UploadStatus.Uploading:
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 case UploadStatus.Finished:
//                   return Center(
//                     child: uploadedUrl==''?Icon(Icons.error):Image.network(uploadedUrl),
//                   );
//                 default:
//                   return Center(child: Text("Something went wrong"));
//               }
//             }));
//   }
// }