import 'package:final_project_md/about_page.dart';
import 'package:final_project_md/favourite_list.dart';
import 'package:final_project_md/readMore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/src/channel.dart';
import 'bloc_functions/api_cubit_state.dart';
import 'package:final_project_md/bloc_functions/api_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'createPost.dart';

// ignore: must_be_immutable
class PostCardList extends StatefulWidget {
  PostCardList({required this.besquare_API, required this.username, Key? key})
      : super(key: key);
  WebSocketChannel besquare_API;
  String username;

  // List<PostsData> storePostData;
  @override
  _PostCardListState createState() => _PostCardListState();
}

class _PostCardListState extends State<PostCardList> {
  // void dosmtg(){
  //   globals
  //
  late var userInputBloc;
  late GetApiData getApiDataCubit;

  List<favouriteList> favList = [];
  final successfulsnackBar = SnackBar(
    content: const Text('Yay! You have deleted your own post!'),
  );
  final failedSnackBar = SnackBar(
    content: const Text('Sorry! You are not the owner of this post!'),
  );
  late String title;
  late String image;
  late String des;

  void showSuccessfulSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(successfulsnackBar);
  }

  void showFailedSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(failedSnackBar);
  }

  void _getFilteredWithDatePostResponse() {
    widget.besquare_API.sink
        .add('{"type": "get_posts", "data": {"sortBy": "date"}}');
  }

  void _getPost() {
    widget.besquare_API.sink.add('{"type": "get_posts"}');
  }

  @override
  void initState() {
    // getApiDataCubit = BlocProvider.of<GetApiData>(context);
    _refresh();
    _getPost();
    super.initState();
  }

  Future<void> _filteredwithdate() {
    _getFilteredWithDatePostResponse();
    return Future.delayed(Duration(seconds: 1));
  }

  Future<void> _refresh() {
    _getPost();
    return Future.delayed(
      Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    // _getPostResponse();
    userInputBloc = BlocProvider.of<GetApiData>(context);
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Posts')),
      body: Center(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => about_page()),
                    );
                  },
                ),
                Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            _filteredwithdate();
                          },
                          icon: const Icon(Icons.sort),
                          alignment: Alignment.topRight,
                        ),
                        IconButton(
                          onPressed: () {
                            _refresh();
                          },
                          icon: const Icon(
                              IconData(58644, fontFamily: 'MaterialIcons')),
                          alignment: Alignment.topRight,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          alignment: Alignment.topRight,
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreatePost(
                                        besquare_API: widget.besquare_API,
                                      )),
                            );
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.blue,
                          ),
                          alignment: Alignment.topRight,
                        ),
                      ]),
                )
              ],
            ),
            BlocConsumer<GetApiData, ApiRequest>(
              bloc: context.read<GetApiData>(),
              builder: (context, state) {
                return state is StoreListData
                    ? state.postDataList.isNotEmpty
                        ? Expanded(
                            child: RefreshIndicator(
                              triggerMode: RefreshIndicatorTriggerMode.onEdge,
                              displacement: 5,
                              edgeOffset: 20,
                              strokeWidth: 5,
                              onRefresh: _refresh,
                              child: ListView.builder(
                                itemCount: state.postDataList.length,
                                itemBuilder: (context, index) {
                                  String idIndex = state.postDataList[index].id;

                                  bool isFavSaved = favList.contains(idIndex);

                                  DateTime tempdate = DateTime.parse(
                                      state.postDataList[index].date);

                                  return Card(
                                    color: Colors.amber[200],
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 30,
                                        bottom: 30,
                                        right: 30,
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          // Text(storePostData[index].description)
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                  left: 5.0,
                                                ),
                                                width: 100,
                                                height: 100,
                                                child: Image.network(
                                                  ('${state.postDataList[index].image}'),
                                                  errorBuilder: (BuildContext
                                                          context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                    return Image(
                                                        image: AssetImage(
                                                            'assets/errorimg.png'));
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                          Expanded(
                                            child: Container(
                                              // color: const Color(
                                              //         0xFF0E3311)
                                              //     .withOpacity(0.1),
                                              padding: const EdgeInsets.all(5),
                                              width: 10,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    // width: 250,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 5,
                                                            bottom: 10),
                                                    decoration:
                                                        new BoxDecoration(
                                                      color: Colors.purple,
                                                      gradient:
                                                          new LinearGradient(
                                                              colors: [
                                                            Colors.yellow,
                                                            Colors.blue
                                                          ],
                                                              begin: Alignment
                                                                  .centerRight,
                                                              end: Alignment
                                                                  .centerLeft),
                                                    ),
                                                    child: Text(
                                                      state.postDataList[index]
                                                          .title,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: new TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 19.5,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 1),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                      left: 5,
                                                    ),
                                                    // padding:
                                                    //     EdgeInsets.only(
                                                    //         right: 1),
                                                    // height: 70,
                                                    // width: 250,
                                                    child: Text(
                                                      'Description: ',
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: new TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                      left: 5,
                                                      bottom: 10,
                                                    ),
                                                    // padding:
                                                    //     EdgeInsets.only(
                                                    //         right: 1),
                                                    // height: 70,
                                                    // width: 250,
                                                    child: Text(
                                                      state.postDataList[index]
                                                          .description,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: new TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                        left: 5.0,
                                                      ),
                                                      child: Text(
                                                        // "${(DateTime.fromMillisecondsSinceEpoch(int.parse(state.postDataList[index].date)))}" *
                                                        //     1000,
                                                        DateFormat(
                                                                "yyyy-MM-dd hh:mm:ss")
                                                            .format(tempdate),
                                                        style: new TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17,
                                                        ),
                                                        // state
                                                        //     .postDataList[
                                                        //         index]
                                                        //     .date,
                                                        maxLines: 1,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Column(
                                          //   children: [Container()],
                                          // )Column(
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if (state.postDataList[
                                                            index] !=
                                                        null) {
                                                      title = state
                                                          .postDataList[index]
                                                          .title;
                                                      image = state
                                                          .postDataList[index]
                                                          .image;
                                                      des = state
                                                          .postDataList[index]
                                                          .description;
                                                      // details.add(detailsPage(
                                                      //   image: state
                                                      //       .postDataList[index]
                                                      //       .image,
                                                      //   title: state
                                                      //       .postDataList[index]
                                                      //       .title,
                                                      //   description: state
                                                      //       .postDataList[index]
                                                      //       .description,

                                                      userInputBloc
                                                          .passDetailsList(
                                                              title,
                                                              image,
                                                              des);
                                                    }
                                                    // print(details);
                                                  });
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            (ReadMoreList(
                                                              besquare_API: widget
                                                                  .besquare_API,
                                                            ))),
                                                  );
                                                },
                                                icon: const Icon(IconData(58634,
                                                    fontFamily:
                                                        'MaterialIcons')),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if (state.postDataList[
                                                            index] !=
                                                        null) {
                                                      favList.add(favouriteList(
                                                        image: state
                                                            .postDataList[index]
                                                            .image,
                                                        title: state
                                                            .postDataList[index]
                                                            .title,
                                                        description: state
                                                            .postDataList[index]
                                                            .description,
                                                        date: state
                                                            .postDataList[index]
                                                            .date,
                                                      ));
                                                    }
                                                  });
                                                },
                                                icon: const Icon(
                                                  // isFavSaved
                                                  //     ? Icons.favorite
                                                  //     : Icons
                                                  //         .favorite_border,
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                  //  isFavSaved
                                                  //     ? Colors.red
                                                  //     : null,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  // if (widget.username ==
                                                  //     state
                                                  //         .postDataList[
                                                  //             index]
                                                  //         .author) {
                                                  if (widget.username ==
                                                      state.postDataList[index]
                                                          .author) {
                                                    userInputBloc.delPost(state
                                                        .postDataList[index]
                                                        .id);
                                                    // _refresh();
                                                    showSuccessfulSnackBar();
                                                  } else {
                                                    showFailedSnackBar();
                                                  }
                                                  // initState();
                                                  // SnackBar(
                                                  //   behavior:
                                                  //       SnackBarBehavior
                                                  //           .floating,
                                                  //   content: Text(
                                                  //       'Text label'),
                                                  //   action:
                                                  //       SnackBarAction(
                                                  //     label: 'Action',
                                                  //     onPressed:
                                                  //         () {},
                                                  //   ),
                                                  // );
                                                  // }
                                                },
                                                icon: const Icon(IconData(
                                                    0xe1b9,
                                                    fontFamily:
                                                        'MaterialIcons')),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        : Text('EMPTY')
                    : SizedBox.shrink();
              },
              listener: (context, state) {
                if (state is deletePost) {
                  widget.besquare_API.sink.add(state.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   // _getPostResponse();
  //   userInputBloc = BlocProvider.of<GetApiData>(context);
  //   return Scaffold(
  //       appBar: AppBar(centerTitle: true, title: const Text('Posts')),
  //       body: Padding(
  //         padding: const EdgeInsets.only(top: 30),
  //         child: SizedBox(
  //           width: MediaQuery.of(context).size.width,
  //           height: MediaQuery.of(context).size.height,
  //           child: Row(
  //             children: [
  //               BlocConsumer<GetApiData, ApiRequest>(
  //                 bloc: context.read<GetApiData>(),
  //                 builder: (context, state) {
  //                   return Expanded(
  //                     child: Row(
  //                       children: [
  //                         state is StoreListData
  //                             ? state.postDataList.isNotEmpty
  //                                 ? Expanded(
  //                                     child: ListView.builder(
  //                                       itemCount: widget.storePostData.length,
  //                                       itemBuilder: (context, index) {
  //                                         return Card(
  //                                           child: Padding(
  //                                             padding: const EdgeInsets.only(
  //                                                 top: 10,
  //                                                 bottom: 10,
  //                                                 right: 10),
  //                                             child: Row(
  //                                               children: <Widget>[
  //                                                 // Text(storePostData[index].description)
  //                                                 Column(
  //                                                   mainAxisAlignment:
  //                                                       MainAxisAlignment
  //                                                           .spaceAround,
  //                                                   crossAxisAlignment:
  //                                                       CrossAxisAlignment
  //                                                           .start,
  //                                                   children: [
  //                                                     Text(widget
  //                                                         .storePostData[index]
  //                                                         .description),
  //                                                   ],
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                           ),
  //                                         );
  //                                       },
  //                                     ),
  //                                   )
  //                                 : Container()
  //                             : SizedBox.shrink(),
  //                       ],
  //                     ),
  //                   );
  //                 },
  //                 listener: (context, state) {},
  //               )
  //             ],
  //           ),
  //         ),
  //       ));
  // }
}

// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/src/channel.dart';
// import 'bloc_functions/api_cubit_state.dart';
// import 'package:final_project_md/bloc_functions/api_cubit.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'main.dart';
// import 'posts_data.dart';

// // ignore: must_be_immutable
// class PostCardList extends StatefulWidget {
//   PostCardList(
//       {required this.besquare_API, required this.storePostData, Key? key})
//       : super(key: key);
//   WebSocketChannel besquare_API;
//   List<PostsData> storePostData;
//   @override
//   _PostCardListState createState() => _PostCardListState();
// }

// class _PostCardListState extends State<PostCardList> {
//   // void dosmtg(){
//   //   globals
//   //
//   late var userInputBloc;
//   late GetApiData getApiDataCubit;

//   void _getPostResponse() {
//     widget.besquare_API.sink.add('{"type": "get_posts"}');
//   }

//   @override
//   void initState() {
//     getApiDataCubit = BlocProvider.of<GetApiData>(context);
//     _getPostResponse();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // _getPostResponse();
//     userInputBloc = BlocProvider.of<GetApiData>(context);
//     return Scaffold(
//         appBar: AppBar(centerTitle: true, title: const Text('Posts')),
//         body: Padding(
//           padding: const EdgeInsets.only(top: 30),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       print("click");
//                     },
//                     icon: Icon(
//                       Icons.favorite,
//                       color: Colors.pink,
//                       size: 24.0,
//                     ),
//                     label: Text('Elevated Button'),
//                     style: ElevatedButton.styleFrom(
//                       shape: new RoundedRectangleBorder(
//                         borderRadius: new BorderRadius.circular(20.0),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height,
//                 child: Row(
//                   children: [
//                     BlocConsumer<GetApiData, ApiRequest>(
//                       bloc: context.read<GetApiData>(),
//                       builder: (context, state) {
//                         return state is StoreListData
//                             ? state.postDataList.isNotEmpty
//                                 ? Expanded(
//                                     child: ListView.builder(
//                                       itemCount: widget.storePostData.length,
//                                       itemBuilder: (context, index) {
//                                         return Card(
//                                           color: Colors.amber[200],
//                                           child: Padding(
//                                             padding: const EdgeInsets.only(
//                                                 top: 200,
//                                                 bottom: 200,
//                                                 right: 200),
//                                             child: Row(
//                                               children: <Widget>[
//                                                 // Text(storePostData[index].description)
//                                                 Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceAround,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Container(
//                                                       width: 200,
//                                                       height: 200,
//                                                       child: Image.network(
//                                                         '${widget.storePostData[index].image}',
//                                                       ),
//                                                     )
//                                                   ],
//                                                 ),
//                                                 Column(
//                                                   children: [],
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   )
//                                 : Container()
//                             : SizedBox.shrink();
//                       },
//                       listener: (context, state) {},
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
//   // Widget build(BuildContext context) {
//   //   // _getPostResponse();
//   //   userInputBloc = BlocProvider.of<GetApiData>(context);
//   //   return Scaffold(
//   //       appBar: AppBar(centerTitle: true, title: const Text('Posts')),
//   //       body: Padding(
//   //         padding: const EdgeInsets.only(top: 30),
//   //         child: SizedBox(
//   //           width: MediaQuery.of(context).size.width,
//   //           height: MediaQuery.of(context).size.height,
//   //           child: Row(
//   //             children: [
//   //               BlocConsumer<GetApiData, ApiRequest>(
//   //                 bloc: context.read<GetApiData>(),
//   //                 builder: (context, state) {
//   //                   return Expanded(
//   //                     child: Row(
//   //                       children: [
//   //                         state is StoreListData
//   //                             ? state.postDataList.isNotEmpty
//   //                                 ? Expanded(
//   //                                     child: ListView.builder(
//   //                                       itemCount: widget.storePostData.length,
//   //                                       itemBuilder: (context, index) {
//   //                                         return Card(
//   //                                           child: Padding(
//   //                                             padding: const EdgeInsets.only(
//   //                                                 top: 10,
//   //                                                 bottom: 10,
//   //                                                 right: 10),
//   //                                             child: Row(
//   //                                               children: <Widget>[
//   //                                                 // Text(storePostData[index].description)
//   //                                                 Column(
//   //                                                   mainAxisAlignment:
//   //                                                       MainAxisAlignment
//   //                                                           .spaceAround,
//   //                                                   crossAxisAlignment:
//   //                                                       CrossAxisAlignment
//   //                                                           .start,
//   //                                                   children: [
//   //                                                     Text(widget
//   //                                                         .storePostData[index]
//   //                                                         .description),
//   //                                                   ],
//   //                                                 ),
//   //                                               ],
//   //                                             ),
//   //                                           ),
//   //                                         );
//   //                                       },
//   //                                     ),
//   //                                   )
//   //                                 : Container()
//   //                             : SizedBox.shrink(),
//   //                       ],
//   //                     ),
//   //                   );
//   //                 },
//   //                 listener: (context, state) {},
//   //               )
//   //             ],
//   //           ),
//   //         ),
//   //       ));
//   // }
// }
