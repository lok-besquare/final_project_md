import 'dart:convert';
import 'package:final_project_md/bloc_functions/api_cubit_state.dart';
import 'package:final_project_md/bloc_functions/api_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'posts_data.dart';
import 'post_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetApiData(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: UserInputPage(title: 'Welcome to Besquare!'),
      ),
    );
  }
}

class UserInputPage extends StatefulWidget {
  UserInputPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _UserInputPageState createState() => _UserInputPageState();
}

class _UserInputPageState extends State<UserInputPage> {
  final _besquare_API =
      WebSocketChannel.connect(Uri.parse('ws://besquare-demo.herokuapp.com'));
  late var userInputBloc;
  final _usernameController = TextEditingController();
  bool _checkController = false;
  late List<PostsData> storePostData = [];
  final snackBar = SnackBar(
    content: const Text('Yay! You have connected to the server!'),
  );

  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    print(storePostData);
    // if (!_checkController) {
    //   ApiStream();
    // } else {
    //   return null;
    // }
    ApiStream();
    _usernameController.addListener(checkController);
    super.initState();
  }

  void checkController() {
    setState(() {
      if (_usernameController.text.isNotEmpty) {
        print('IS NOT EMPTY');
        _checkController = true;
      } else {
        _checkController = false;
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _besquare_API.sink.close();
    super.dispose();
  }

  // ignore: non_constant_identifier_names
  void ApiStream() {
    _besquare_API.stream.listen((message) {
      final decodedMessage = jsonDecode(message);

      print(decodedMessage);
      List<PostsData> storeTempPostData = [];
      if (decodedMessage["type"] == "all_posts" &&
          decodedMessage["data"]["posts"] != null) {
        decodedMessage["data"]["posts"].forEach((data) {
          setState(() {
            storeTempPostData.add(PostsData(
              data["_id"],
              data["title"],
              data["description"],
              data["image"],
              data["date"],
              data["author"],
            ));
          });
          print('HERE');
          print(storePostData);
          storePostData = storeTempPostData;
        });
        // BlocProvider.of<GetApiData>(context).passData(storePostData);
        userInputBloc.passData(storePostData);
      }
      if (decodedMessage["type"] == "delete_post") {
        _besquare_API.sink
            .add('{"type": "get_posts", "data": {"sortBy": "date"}}');
      }
    });
    // print(userInputBloc.passData(storePostData));

    // _besquare_API.sink.add('{"type": "get_posts"}');
  }

  void callSignInBlocFunction() {
    if (_checkController) {
      // _besquare_API.sink
      //     .add(userInputBloc.checkSignIn(_usernameController.text));

      userInputBloc.checkSignIn(_usernameController.text);
      // userInputBloc.checkSignIn(_usernameController.text);
      showSnackBar();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PostCardList(
                  besquare_API: _besquare_API,
                  username: _usernameController.text,

                  // storePostData: storePostData,
                )),
      );
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => PostCardList(
      //             besquare_API: _besquare_API,
      //             storePostData: storePostData,
      //           )),
      // );
    } else {
      print('ARRIVED ELSE');
      userInputBloc.CheckIsNotValid();
      SnackBar(
          content: const Text('Sorry! You are not connected to the server!'));
    }
  }

  void _getSignInResponse(String userInput) {
    _besquare_API.sink
        .add('{"type": "sign_in", "data": {"name": "$userInput"}}');
  }

  void _getToPost(String title, String description, String image) {
    _besquare_API.sink.add(
        '{"type": "create_post", "data": {"title": "$title", "description": "$description", "image": "$image"}}');
  }

  void _getTodeletePost(String postId) {
    _besquare_API.sink
        .add('{"type": "delete_post", "data": {"postId": "$postId"}}');
  }

  @override
  Widget build(BuildContext context) {
    userInputBloc = BlocProvider.of<GetApiData>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Welcome to Besquare"),
          centerTitle: true,
        ),
        body: BlocConsumer<GetApiData, ApiRequest>(
          bloc: context.read<GetApiData>(),
          builder: (context, state) {
            return Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text('BePosted',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 45,
                            )),
                        SizedBox(height: 10),
                        Image(
                          image: AssetImage('assets/pumpkin.png'),
                          color: const Color.fromRGBO(255, 255, 255, 0.8),
                          colorBlendMode: BlendMode.modulate,
                          height: 200,
                          width: 200,
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 35,
                            right: 35,
                          ),
                          child: TextFormField(
                              maxLength: 20,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                icon: Icon(IconData(57938,
                                    fontFamily: 'MaterialIcons')),
                                labelText: 'Username',
                                hintText: 'Enter your username...',
                              ),
                              controller: _usernameController),
                        ),
                        ElevatedButton(
                          onPressed: !_checkController
                              ? null
                              : () {
                                  callSignInBlocFunction();
                                  // String username =
                                  //     (_usernameController.toString());
                                  // context
                                  //     .read<GetApiData>()
                                  //     .checkSignIn(username);
                                  // .read<GetApiData>()
                                  // .checkSignIn(username);
                                  // Navigator.of(context).pushReplacement(
                                  //   MaterialPageRoute(
                                  //       builder: (context) => PostCardList()),
                                  // );
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => PostCardList(
                                  //             besquare_API: _besquare_API,
                                  //             storePostData: storePostData,
                                  //           )),
                                  // );
                                },
                          child: Text('ENTER TO THE APP'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          listener: (context, state) {
            if (state is SignInRequest && _checkController == true) {
              print("LISTENER ACTIVATED");
              // scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
              //     content: const Text(
              //         'Congratz! You have successfully connected to the server.')));
              _besquare_API.sink.add('${state.userNameInput}');
            }
          },
        ));
  }

  // ignore: non_constant_identifier_names
  // Widget PostCardList() {
  //   _getPostResponse();
  //   userInputBloc = BlocProvider.of<GetApiData>(context);
  //   return Scaffold(
  //       appBar: AppBar(centerTitle: true, title: const Text('Posts')),
  //       body: Padding(
  //         padding: const EdgeInsets.only(top: 30),
  //         child: SizedBox(
  //           width: MediaQuery.of(context).size.width,
  //           height: MediaQuery.of(context).size.height,
  //           child: Expanded(
  //             child: Row(
  //               children: [
  //                 BlocConsumer<GetApiData, CheckDataValidity>(
  //                   bloc: context.read<GetApiData>(),
  //                   builder: (context, state) {
  //                     return Expanded(
  //                       child: Row(
  //                         children: [
  //                           storePostData.isNotEmpty
  //                               ? Expanded(
  //                                   child: ListView.builder(
  //                                     itemCount: storePostData.length,
  //                                     itemBuilder: (context, index) {
  //                                       return Card(
  //                                         child: Padding(
  //                                           padding: const EdgeInsets.only(
  //                                               top: 10, bottom: 10, right: 10),
  //                                           child: Row(
  //                                             children: <Widget>[
  //                                               // Text(storePostData[index].description)
  //                                               Column(
  //                                                 mainAxisAlignment:
  //                                                     MainAxisAlignment
  //                                                         .spaceAround,
  //                                                 crossAxisAlignment:
  //                                                     CrossAxisAlignment.start,
  //                                                 children: [
  //                                                   Text(storePostData[index]
  //                                                       .description),
  //                                                 ],
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                       );
  //                                     },
  //                                   ),
  //                                 )
  //                               : Container()
  //                         ],
  //                       ),
  //                     );
  //                   },
  //                   listener: (context, state) {},
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //       ));

}
