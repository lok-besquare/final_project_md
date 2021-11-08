import 'package:final_project_md/bloc_functions/api_cubit.dart';
import 'package:final_project_md/bloc_functions/api_cubit_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ReadMoreList extends StatefulWidget {
  ReadMoreList({required this.besquare_API, Key? key}) : super(key: key);

  // List<PostsData> storePostData;
  WebSocketChannel besquare_API;
  @override
  _ReadMoreListState createState() => _ReadMoreListState();
}

class _ReadMoreListState extends State<ReadMoreList> {
  void refresh() {
    widget.besquare_API.sink.add('{"type": "get_posts"}');
  }

  Future<void> _refresh() {
    refresh();
    return Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text('Details Page'),
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(_refresh()))),
        body: Center(
          child: BlocBuilder<GetApiData, ApiRequest>(
            builder: (context, state) {
              return state is StoreDetailsList
                  ? Center(
                      child: ListView(shrinkWrap: true, children: [
                      Center(
                        child: Column(
                          children: [
                            Text(
                              "Title:",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              width: 300,
                              padding: EdgeInsets.only(
                                  left: 5, right: 5, top: 20, bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.redAccent,
                                    blurRadius: 4,
                                    offset: Offset(4, 8), // Shadow position
                                  ),
                                ],
                              ),
                              child: Text(
                                state.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                // overflow: TextOverflow.ellipsis,
                                // maxLines: 1
                              ),
                            ),
                            SizedBox(height: 13),
                            Image.network(
                              ('${state.image}'),
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Image(
                                    image: AssetImage('assets/empty.png'));
                              },
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: 500,
                              padding: EdgeInsets.only(
                                  left: 5, right: 5, top: 20, bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.yellow[600],
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 4,
                                    offset: Offset(4, 8), // Shadow position
                                  ),
                                ],
                              ),
                              child: Text(
                                state.description,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ),
                    ]))
                  : SizedBox.shrink();
            },
          ),
        ));
  }
}

// return Center(
//                               child: Column(
//                                 children: [
//                                   Text(state.detailsList[index].title,
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 45,
//                                       )),
//                                   Image.network(
//                                     ('${state.detailsList[index].image}'),
//                                     errorBuilder: (BuildContext context,
//                                         Object exception,
//                                         StackTrace? stackTrace) {
//                                       return Image(
//                                           image:
//                                               AssetImage('assets/empty.png'));
//                                     },
//                                   ),
//                                   Text(
//                                     state.detailsList[index].description,
//                                   )
//                                 ],
//                               ),
//                             );
