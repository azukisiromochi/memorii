              // body: Column(
              //   children: [
              //     Container(
              //       child: Container(
              //         child: Stack(
              //           children: [
              //             Container(
              //               width: double.infinity,
              //               height: 140,
              //               color: Color(0xFFFF8D89),
              //             ),
              //             Stack(
              //               children: [
              //                 Container(
              //                   width: 80.w,
              //                   margin: EdgeInsets.only(top: 80, right: 10.w, left: 10.w),
              //                   padding: EdgeInsets.only(bottom: 20,),
              //                   decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(10),
              //                     color: Colors.white,
              //                     boxShadow: [
              //                       BoxShadow(
              //                         color: Colors.black12,
              //                         blurRadius: 20.0,
              //                         spreadRadius: 1.0,
              //                         offset: Offset(0, 0)
              //                       ),
              //                     ],
              //                   ),
              //                   child: Column(
              //                     children: [
              //                       Container(
              //                         margin: EdgeInsets.only(top: 60, right: 10.w, left: 10.w),
              //                         child: UserData.instance.account.length > 0 ? Text(
              //                           UserData.instance.account[0]["user_name"] != "" ?
              //                           UserData.instance.account[0]["user_name"] : "unnamed",
              //                           textAlign: TextAlign.center,
              //                           style: TextStyle(
              //                             fontWeight: FontWeight.bold,
              //                             color: Colors.black87,
              //                             fontSize: 20,
              //                           ),
              //                         ) : Text(""),
              //                       ),
              //                       Container(
              //                         margin: EdgeInsets.only(top: 0, right: 10.w, left: 10.w),
              //                         child: UserData.instance.account.length > 0 ? Text(
              //                           UserData.instance.account[0]["user_short"],
              //                           textAlign: TextAlign.center,
              //                           style: TextStyle(
              //                             fontWeight: FontWeight.bold,
              //                             color: Colors.black26,
              //                             fontSize: 12,
              //                           ),
              //                         ) : Text(""),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //                 UserData.instance.account.length > 0 ?
              //                 UserData.instance.account[0]["user_image_500"] == "" ?
              //                 Container(
              //                   height: 110,
              //                   width: 30.w,
              //                   margin: EdgeInsets.only(top: 20, right: 35.w, left: 35.w),
              //                   padding: EdgeInsets.all(5.0),
              //                   decoration: BoxDecoration(
              //                     color: Color(0xFFFFFFFF),
              //                     shape: BoxShape.circle,
              //                     border: Border.all(
              //                       color: Colors.white,
              //                       width: 5,
              //                     ),
              //                     image: DecorationImage(
              //                       fit: BoxFit.cover,
              //                       image: FileImage(
              //                         File(
              //                           UserData.instance.account[0]["user_image_path"].replaceFirst('File: \'', '').replaceFirst('\'', ''),
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //                 )
              //                 :
              //                 Container(
              //                   height: 110,
              //                   width: 30.w,
              //                   margin: EdgeInsets.only(top: 20, right: 35.w, left: 35.w),
              //                   child: CircleAvatar(
              //                     radius: 100,
              //                     backgroundColor: Colors.white,
              //                     backgroundImage: NetworkImage(
              //                       UserData.instance.account[0]["user_image_500"],
              //                     ),
              //                   ),
              //                   padding: EdgeInsets.all(5.0),
              //                   decoration: BoxDecoration(
              //                     color: Color(0xFFFFFFFF),
              //                     shape: BoxShape.circle,
              //                   )
              //                 ) : Container(),
              //               ]
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //     Container(
              //       margin: EdgeInsets.only(top: 30, right: 10.w, left: 10.w,),
              //       height: 30,
              //       child: TabBar(
              //         controller: _controller,
              //         unselectedLabelColor: Color(0xFFFF8D89),
              //         indicatorSize: TabBarIndicatorSize.tab,
              //         indicator: BoxDecoration(
              //           borderRadius: BorderRadius.circular(5),
              //           color: Color(0xFFFF8D89),
              //         ),
              //         tabs: [
              //           Tab(
              //             child: Align(
              //               alignment: Alignment.center,
              //               child: Text("APPS"),
              //             ),
              //           ),
              //           Tab(
              //             child: Align(
              //               alignment: Alignment.center,
              //               child: Text("MOVIES"),
              //             ),
              //           ),
              //           Tab(
              //             child: Align(
              //               alignment: Alignment.center,
              //               child: Text("MOVIESs"),
              //             ),
              //           ),
              //         ]
              //       ),
              //     ),
              //     Expanded(
              //       child: 
              //       TabBarView(
              //         controller: _controller,

              //         children: [
              //           Container(
              //             width: 80.w,
              //             margin: EdgeInsets.only(top: 20, right: 10.w, left: 10.w),
              //             child: StreamBuilder(
              //               stream: FirebaseFirestore.instance
              //                 .collection('posts')
              //                 .where('post_uid', isEqualTo: UserData.instance.user)
              //                 .orderBy("post_time", descending: true)
              //                 .snapshots(),
              //               builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              //                 if (snapshot.hasData) {
              //                   return GridView.count(
              //                     // physics: NeverScrollableScrollPhysics(),
              //                     // shrinkWrap: true,
              //                     physics: BouncingScrollPhysics(
              //                       parent: AlwaysScrollableScrollPhysics()
              //                     ),
              //                     crossAxisCount: 2,
              //                     childAspectRatio: 7.0 / 7.0,
              //                     children: snapshot.data!.docs.map((document) {
              //                       return Container(
              //                         margin: EdgeInsets.all(5),
              //                         child: Stack(
              //                           children: <Widget>[
              //                             AspectRatio(
              //                               aspectRatio: 11.0 / 11.0,
              //                               child: document["post_image_500"] == "" ?
              //                               GestureDetector(
              //                                 child: Container(
              //                                   decoration: BoxDecoration(
              //                                     image: DecorationImage(
              //                                       fit: BoxFit.cover,
              //                                       image: FileImage(
              //                                         File(
              //                                           document["post_image_path"].replaceFirst('File: \'', '').replaceFirst('\'', ''),
              //                                         ),
              //                                       ),
              //                                     ), 
              //                                   ),
              //                                 ),
              //                                 onTap: () async {
              //                                   await Navigator.push(
              //                                     context,MaterialPageRoute(builder: (context) => PhotoEdit(document.id)),
              //                                   );
              //                                   // start();
              //                                 },
              //                               )
              //                               :
              //                               GestureDetector(
              //                                 child: ClipRRect(
              //                                   borderRadius: BorderRadius.circular(5.0),
              //                                   child: Image.network(
              //                                     document["post_image_500"],
              //                                     fit: BoxFit.cover,
              //                                   ),
              //                                 ),
              //                                 onTap: () async {
              //                                   await Navigator.push(
              //                                     context,MaterialPageRoute(builder: (context) => PhotoEdit(document.id)),
              //                                   );
              //                                   // start();
              //                                 },
              //                               ),
              //                             ),
              //                           ],
              //                         ),
              //                       );
              //                     }).toList(),
              //                   );
              //                 } else {
              //                   return Container();
              //                 }
              //               },
              //             ),
              //           ),
              //           Container(
              //             margin: EdgeInsets.only(top: 20),
              //             child: StreamBuilder(
              //               stream: FirebaseFirestore.instance
              //                 .collection('tweets')
              //                 .orderBy("tweet_time", descending: true)
              //                 .snapshots(),
              //               builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              //                 if (snapshot.hasData) {
              //                   return Container(
              //                     child: ListView.builder(
              //                       physics: NeverScrollableScrollPhysics(),
              //                       shrinkWrap: true,
              //                       itemCount: snapshot.data!.docs.length,
              //                       itemBuilder: (document, index) {
              //                         return Container(
              //                           margin: EdgeInsets.only(right: 10.w, left: 10.w,),
              //                           padding: EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10,),
              //                           decoration: BoxDecoration(
              //                             border: Border(
              //                               bottom: BorderSide(
              //                                 color: Colors.black12,
              //                                 width: 1,
              //                               ),
              //                             ),
              //                           ),
              //                           child: Column(
              //                             children: [
              //                               Stack(
              //                                 children: [
              //                                   Row(
              //                                     children: [
              //                                       // Column(
              //                                       //   children: [
              //                                       //     Container(
              //                                       //       height: 60,
              //                                       //       width: 60,
              //                                       //       margin: EdgeInsets.only(right: 15,),
              //                                       //     ),
              //                                       //   ]
              //                                       // ),
              //                                       Column(
              //                                         children: [
              //                                           Container(
              //                                             width: 74.w,
              //                                             child: Text(
              //                                               snapshot.data!.docs[index]["tweet_name"],
              //                                               textAlign: TextAlign.left,
              //                                               style: TextStyle(
              //                                                 fontWeight: FontWeight.bold,
              //                                                 fontSize: 15,
              //                                               ),
              //                                             ),
              //                                           ),
              //                                           Container(
              //                                             width: 74.w,
              //                                             child: Linkable(
              //                                               text: snapshot.data!.docs[index]["tweet_text"],
              //                                               textColor: Colors.black87,
              //                                               style: TextStyle(
              //                                                 fontSize: 14,
              //                                               ),
              //                                             ),
              //                                           ),
              //                                           snapshot.data!.docs[index]["tweet_photo_1080"] != '' ? Container(
              //                                             width: 74.w,
              //                                             height: 74.w,
              //                                             margin: EdgeInsets.only(top: 5,),
              //                                             child: ClipRRect(
              //                                               borderRadius: BorderRadius.circular(5.0),
              //                                               child: Image.network(
              //                                                 snapshot.data!.docs[index]["tweet_photo_1080"],
              //                                                 fit: BoxFit.cover,
              //                                               ),
              //                                             ),
              //                                           ) : Container(),
              //                                           Container(
              //                                             width: 74.w,
              //                                             child: Row(
              //                                               mainAxisAlignment: MainAxisAlignment.start,
              //                                               children: [
              //                                                 // GestureDetector(
              //                                                 //   child: Container(
              //                                                 //     padding: EdgeInsets.only(top: 5, bottom: 5, right: 5.w, left: 5.w,),
              //                                                 //     margin: EdgeInsets.only(top: 10, left: 0),
              //                                                 //     decoration: BoxDecoration(
              //                                                 //       border: Border.all(
              //                                                 //         color: Color(0xFFFF8D89),
              //                                                 //         width: 1,
              //                                                 //       ),
              //                                                 //       borderRadius: BorderRadius.circular(5),
              //                                                 //     ),
              //                                                 //     child: Text(
              //                                                 //       'instagram',
              //                                                 //       style: TextStyle(
              //                                                 //         color: Color(0xFFFF8D89),
              //                                                 //         fontSize: 12,
              //                                                 //         fontWeight: FontWeight.bold,
              //                                                 //       ),
              //                                                 //     ),
              //                                                 //   ),
              //                                                 //   onTap: () async {
              //                                                 //     var url = 'https://www.instagram.com/${snapshot.data!.docs[index]["tweet_instagram"]}';
              //                                                 //     if (await canLaunch(url)) {
              //                                                 //       await launch(
              //                                                 //         url,
              //                                                 //         forceSafariVC: true,
              //                                                 //         forceWebView: true,
              //                                                 //       );
              //                                                 //     } else {
              //                                                 //       throw 'このURLにはアクセスできません';
              //                                                 //     }
              //                                                 //   }
              //                                                 // ),
              //                                                 // GestureDetector(
              //                                                 //   child: Container(
              //                                                 //     padding: EdgeInsets.only(top: 5, bottom: 5, right: 5.w, left: 5.w,),
              //                                                 //     margin: EdgeInsets.only(top: 10, left: 10,),
              //                                                 //     decoration: BoxDecoration(
              //                                                 //       color: Colors.white,
              //                                                 //       border: Border.all(
              //                                                 //         color: Color(0xFFFF8D89),
              //                                                 //         width: 1,
              //                                                 //       ),
              //                                                 //       borderRadius: BorderRadius.circular(5),
              //                                                 //     ),
              //                                                 //     child: Text(
              //                                                 //       'tiktok',
              //                                                 //       // UserData.instance.account[0]["user_instagram"],
              //                                                 //       style: TextStyle(
              //                                                 //         color: Color(0xFFFF8D89),
              //                                                 //         fontSize: 12,
              //                                                 //         fontWeight: FontWeight.bold,
              //                                                 //       ),
              //                                                 //     ),
              //                                                 //   ),
              //                                                 //   onTap: () async {
              //                                                 //     var url = 'https://www.tiktok.com/@${snapshot.data!.docs[index]["tweet_tiktok"]}';
              //                                                 //     if (await canLaunch(url)) {
              //                                                 //       await launch(
              //                                                 //         url,
              //                                                 //         forceSafariVC: true,
              //                                                 //         forceWebView: true,
              //                                                 //       );
              //                                                 //     } else {
              //                                                 //       throw 'このURLにはアクセスできません';
              //                                                 //     }
              //                                                 //   },
              //                                                 // ),
              //                                               ],
              //                                             ),
              //                                           ),
              //                                         ],
              //                                       ),
              //                                     ],
              //                                   ),
              //                                   // Container(
              //                                   //   height: 60,
              //                                   //   width: 60,
              //                                   //   margin: EdgeInsets.only(right: 10,),
              //                                   //   child: CircleAvatar(
              //                                   //     radius: 100,
              //                                   //     backgroundImage: NetworkImage(
              //                                   //       snapshot.data!.docs[index]["tweet_image_500"],
              //                                   //     ),
              //                                   //   ),
              //                                   // ),
              //                                 ],
              //                               ),
              //                             ],
              //                           ),
              //                         );
              //                       }
              //                     ),
              //                   );
              //                 } else {
              //                   return Container();
              //                 }
              //               },
              //             ),
              //           ),
              //           Container(
              //             width: 80.w,
              //             margin: EdgeInsets.only(top: 20, right: 10.w, left: 10.w),
              //             child: StreamBuilder(
              //               stream: FirebaseFirestore.instance
              //                 .collection('posts')
              //                 .where('post_liker', arrayContains: UserData.instance.user)
              //                 .snapshots(),
              //               builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              //                 if (snapshot.hasData) {
              //                   return GridView.count(
              //                     // physics: NeverScrollableScrollPhysics(),
              //                     // shrinkWrap: true,
              //                     crossAxisCount: 2,
              //                     childAspectRatio: 7.0 / 7.0,
              //                     children: snapshot.data!.docs.map((document) {
              //                       return Container(
              //                         margin: EdgeInsets.all(5),
              //                         child: Stack(
              //                           children: <Widget>[
              //                             AspectRatio(
              //                               aspectRatio: 11.0 / 11.0,
              //                               child: document["post_image_500"] == "" ?
              //                               GestureDetector(
              //                                 child: Container(
              //                                   decoration: BoxDecoration(
              //                                     image: DecorationImage(
              //                                       fit: BoxFit.cover,
              //                                       image: FileImage(
              //                                         File(
              //                                           document["post_image_path"].replaceFirst('File: \'', '').replaceFirst('\'', ''),
              //                                         ),
              //                                       ),
              //                                     ), 
              //                                   ),
              //                                 ),
              //                                 onTap: () async {
              //                                   await Navigator.push(
              //                                     context,MaterialPageRoute(builder: (context) => PhotoEdit(document.id)),
              //                                   );
              //                                   // start();
              //                                 },
              //                               )
              //                               :
              //                               GestureDetector(
              //                                 child: ClipRRect(
              //                                   borderRadius: BorderRadius.circular(5.0),
              //                                   child: Image.network(
              //                                     document["post_image_500"],
              //                                     fit: BoxFit.cover,
              //                                   ),
              //                                 ),
              //                                 onTap: () async {
              //                                   await Navigator.push(
              //                                     context,MaterialPageRoute(builder: (context) => PhotoEdit(document.id)),
              //                                   );
              //                                   // start();
              //                                 },
              //                               ),
              //                             ),
              //                           ],
              //                         ),
              //                       );
              //                     }).toList(),
              //                   );
              //                 } else {
              //                   return Container();
              //                 }
              //               },
              //             ),
              //           ),
              //         ]
              
              //       ),
              //     ),
              //   ],
              // ),