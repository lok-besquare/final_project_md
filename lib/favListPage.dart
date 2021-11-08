// import 'package:final_project_md/bloc_functions/api_cubit.dart';
// import 'package:final_project_md/bloc_functions/api_cubit_state.dart';
// import 'package:final_project_md/readMore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class FavPage extends StatefulWidget {
//   FavPage({required this.besquare_API, required this.username, Key? key})
//       : super(key: key);

//   // List<PostsData> storePostData;
//   WebSocketChannel besquare_API;
//   String username;
//   @override
//   _FavPageState createState() => _FavPageState();
// }

// class _FavPageState extends State<FavPage> {
//   late final userInputBloc;
//   // final successfulsnackBar = SnackBar(
//   //   content: const Text('Yay! You have deleted your own post!'),
//   // );
//   // final failedSnackBar = SnackBar(
//   //   content: const Text('Sorry! You are not the owner of this post!'),
//   // );
//   // void showSuccessfulSnackBar() {
//   //   ScaffoldMessenger.of(context).showSnackBar(successfulsnackBar);
//   // }

//   // void showFailedSnackBar() {
//   //   ScaffoldMessenger.of(context).showSnackBar(failedSnackBar);
//   // }

//   void refresh() {
//     widget.besquare_API.sink.add('{"type": "get_posts"}');
//   }

//   Future<void> _refresh() {
//     refresh();
//     return Future.delayed(Duration(seconds: 1));
//   }

//   @override
//   Widget build(BuildContext context) {
//     // _getPostResponse();
//     userInputBloc = BlocProvider.of<GetApiData>(context);
//     return Scaffold(
//       appBar: AppBar(
//           centerTitle: true,
//           title: const Text('Favorite Posts'),
//           leading: IconButton(
//               icon: Icon(Icons.arrow_back, color: Colors.black),
//               onPressed: () => Navigator.of(context).pop(_refresh()))),
//       body: Center(
//         child: Column(
//           children: <Widget>[
//             BlocBuilder<GetApiData, ApiRequest>(
//               bloc: context.read<GetApiData>(),
//               builder: (context, state) {
//                 return state is StoreFavList
//                     ? state.favList.isNotEmpty
//                         ? Expanded(
//                             child: ListView.builder(
//                               itemCount: state.favList.length,
//                               itemBuilder: (context, index) {
//                                 // String idIndex = state.favList[index].id;

//                                 // bool isFavSaved = favList.contains(idIndex);

//                                 DateTime tempdate =
//                                     DateTime.parse(state.favList[index].date);

//                                 return Card(
//                                   color: Colors.amber[200],
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(
//                                       top: 30,
//                                       bottom: 30,
//                                       right: 30,
//                                     ),
//                                     child: Row(
//                                       children: <Widget>[
//                                         // Text(storePostData[index].description)
//                                         Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceAround,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Container(
//                                               margin: const EdgeInsets.only(
//                                                 left: 5.0,
//                                               ),
//                                               width: 100,
//                                               height: 100,
//                                               child: Image.network(
//                                                 ('${state.favList[index].image}'),
//                                                 errorBuilder: (BuildContext
//                                                         context,
//                                                     Object exception,
//                                                     StackTrace? stackTrace) {
//                                                   return Image(
//                                                       image: AssetImage(
//                                                           'assets/errorimg.png'));
//                                                 },
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                         Expanded(
//                                           child: Container(
//                                             // color: const Color(
//                                             //         0xFF0E3311)
//                                             //     .withOpacity(0.1),
//                                             padding: const EdgeInsets.all(5),
//                                             width: 10,
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: <Widget>[
//                                                 Container(
//                                                   // width: 250,
//                                                   margin: const EdgeInsets.only(
//                                                       left: 5, bottom: 10),
//                                                   decoration: new BoxDecoration(
//                                                     color: Colors.purple,
//                                                     gradient:
//                                                         new LinearGradient(
//                                                             colors: [
//                                                           Colors.yellow,
//                                                           Colors.blue
//                                                         ],
//                                                             begin: Alignment
//                                                                 .centerRight,
//                                                             end: Alignment
//                                                                 .centerLeft),
//                                                   ),
//                                                   child: Text(
//                                                     state.favList[index].title,
//                                                     maxLines: 2,
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                     style: new TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       fontSize: 19.5,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 SizedBox(height: 1),
//                                                 Container(
//                                                   margin: const EdgeInsets.only(
//                                                     left: 5,
//                                                   ),
//                                                   // padding:
//                                                   //     EdgeInsets.only(
//                                                   //         right: 1),
//                                                   // height: 70,
//                                                   // width: 250,
//                                                   child: Text(
//                                                     'Description: ',
//                                                     maxLines: 2,
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                     style: new TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       fontSize: 16,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   margin: const EdgeInsets.only(
//                                                     left: 5,
//                                                     bottom: 10,
//                                                   ),
//                                                   // padding:
//                                                   //     EdgeInsets.only(
//                                                   //         right: 1),
//                                                   // height: 70,
//                                                   // width: 250,
//                                                   child: Text(
//                                                     state.favList[index]
//                                                         .description,
//                                                     maxLines: 2,
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                     style: new TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.normal,
//                                                       fontSize: 16,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                     margin:
//                                                         const EdgeInsets.only(
//                                                       left: 5.0,
//                                                     ),
//                                                     child: Text(
//                                                       // "${(DateTime.fromMillisecondsSinceEpoch(int.parse(state.favList[index].date)))}" *
//                                                       //     1000,
//                                                       DateFormat(
//                                                               "yyyy-MM-dd hh:mm:ss")
//                                                           .format(tempdate),
//                                                       style: new TextStyle(
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                         fontSize: 17,
//                                                       ),
//                                                       // state
//                                                       //     .favList[
//                                                       //         index]
//                                                       //     .date,
//                                                       maxLines: 1,
//                                                     )),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         // Column(
//                                         //   children: [Container()],
//                                         // )Column(
//                                         Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           children: [
//                                             IconButton(
//                                               onPressed: () {
//                                                 setState(() {
//                                                   // state.favList[index]
//                                                   if (state.favList[index] !=
//                                                       null) {
//                                                     var title = state
//                                                         .favList[index].title;
//                                                     var image = state
//                                                         .favList[index].image;
//                                                     var des = state
//                                                         .favList[index]
//                                                         .description;
//                                                     // details.add(detailsPage(
//                                                     //   image: state
//                                                     //       .favList[index]
//                                                     //       .image,
//                                                     //   title: state
//                                                     //       .favList[index]
//                                                     //       .title,
//                                                     //   description: state
//                                                     //       .favList[index]
//                                                     //       .description,

//                                                     userInputBloc
//                                                         .passDetailsList(
//                                                             title, image, des);

//                                                     // print(details);
//                                                   }
//                                                 });
//                                                 Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                       builder: (context) =>
//                                                           (ReadMoreList(
//                                                             besquare_API: widget
//                                                                 .besquare_API,
//                                                           ))),
//                                                 );
//                                               },
//                                               icon: const Icon(IconData(58634,
//                                                   fontFamily: 'MaterialIcons')),
//                                             ),
//                                             IconButton(
//                                               onPressed: () {
//                                                 // setState(() {
//                                                 state.favList.removeAt(index);
//                                                 // });
//                                               },
//                                               icon: const Icon(
//                                                 // isFavSaved
//                                                 //     ? Icons.favorite
//                                                 //     : Icons
//                                                 //         .favorite_border,
//                                                 Icons.favorite,
//                                                 color: Colors.red,
//                                                 //  isFavSaved
//                                                 //     ? Colors.red
//                                                 //     : null,
//                                               ),
//                                             ),
//                                             // IconButton(
//                                             //   onPressed: () {
//                                             //     // if (widget.username ==
//                                             //     //     state
//                                             //     //         .favList[
//                                             //     //             index]
//                                             //     //         .author) {
//                                             //     if (widget.username ==
//                                             //         state.favList[index]
//                                             //             .author) {
//                                             //       userInputBloc.delPost(
//                                             //           state.favList[index].id);
//                                             //       // _refresh();
//                                             //       showSuccessfulSnackBar();
//                                             //     } else {
//                                             //       showFailedSnackBar();
//                                             //     }
//                                             //     // initState();
//                                             //     // SnackBar(
//                                             //     //   behavior:
//                                             //     //       SnackBarBehavior
//                                             //     //           .floating,
//                                             //     //   content: Text(
//                                             //     //       'Text label'),
//                                             //     //   action:
//                                             //     //       SnackBarAction(
//                                             //     //     label: 'Action',
//                                             //     //     onPressed:
//                                             //     //         () {},
//                                             //     //   ),
//                                             //     // );
//                                             //     // }
//                                             //   },
//                                             //   icon: const Icon(IconData(0xe1b9,
//                                             //       fontFamily: 'MaterialIcons')),
//                                             // ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           )
//                         : Text('EMPTY')
//                     : SizedBox.shrink();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
