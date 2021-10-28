// import 'package:flutter/cupertino%202.dart';
// import 'package:flutter/material.dart';
// import 'dart:ui';
// import 'package:html_editor/html_editor.dart';

// class Html extends StatefulWidget {

//   @override
//   _HtmlState createState() => _HtmlState();
// }

// class _HtmlState extends State<Html> {

//   GlobalKey<HtmlEditorState> keyEditor = GlobalKey();
//   String result = "";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Stack(
//           alignment: Alignment.center,
//           children: <Widget>[
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: GestureDetector(
//                   child: Icon(
//                     Icons.clear_outlined,
//                     color: Colors.black87,
//                   ),
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.center,
//               child: Text(
//                 "作品投稿",
//                 style: TextStyle(
//                   color: Colors.black87,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 15
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.centerRight,
//               child: GestureDetector(
//                 child: Container(
//                   margin: EdgeInsets.only(right: 10,),
//                   child: Text(
//                     '画像',
//                     style: TextStyle(
//                       color: Color(0xFFFF8D89),
//                       fontWeight: FontWeight.bold,
//                       fontSize: 15
//                     ),
//                   ),
//                 ),
//                 onTap: () {
//                 },
//               )
//             )
//           ],
//         ),
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         elevation: 0.0,
//       ),
//       body: Container(
//         child: Padding(
//         padding: const EdgeInsets.all(20),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 HtmlEditor(
//                   hint: "Your text here...",
//                   //value: "text content initial, if any",
//                   key: keyEditor,
//                   height: 400,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       TextButton(
//                         style: TextButton.styleFrom(
//                           primary: Colors.blueGrey,
//                         ),
//                         onPressed: (){
//                           setState(() {
//                             keyEditor.currentState!.setEmpty();
//                           });
//                         },
//                         child: Text("Reset", style: TextStyle(color: Colors.white)),
//                       ),
//                       SizedBox(width: 16,),
//                       TextButton(
//                         style: TextButton.styleFrom(
//                           primary: Colors.blueGrey,
//                         ),
//                         onPressed: () async {
//                           final txt = await keyEditor.currentState!.getText();
//                           setState(() {
//                             result = txt;
//                           });
//                         },
//                         child: Text("Submit", style: TextStyle(color: Colors.white),),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(result),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }