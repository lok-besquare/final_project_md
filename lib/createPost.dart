import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:final_project_md/bloc_functions/api_cubit_state.dart';
import 'package:final_project_md/bloc_functions/api_cubit.dart';
import 'bloc_functions/api_cubit.dart';

// class CreatePost extends StatefulWidget{

// }
// ignore: must_be_immutable
class CreatePost extends StatefulWidget {
  CreatePost({required this.besquare_API, Key? key}) : super(key: key);
  WebSocketChannel besquare_API;
  // List<PostsData> storePostData;
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  bool _checkController = false;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late var userInputBloc;
  final _imageController = TextEditingController();
  final snackBar = SnackBar(
    content: const Text('Yay! You have created a post!'),
  );

  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    _titleController.addListener(checkController);
    _descriptionController.addListener(checkController);

    _imageController.addListener(checkController);
    // refreshPost();
    super.initState();
  }

  Future refreshPost() async {
    widget.besquare_API.sink.add('{"type": "get_posts"}');
  }

  void checkController() {
    setState(() {
      if (_titleController.text.isNotEmpty &&
          _descriptionController.text.isNotEmpty &&
          _imageController.text.isNotEmpty) {
        print('IS NOT EMPTY');
        _checkController = true;
      } else {
        _checkController = false;
      }
    });
  }

  void callAddPostBlocFunction() {
    if (_checkController) {
      // _besquare_API.sink
      //     .add(userInputBloc.checkSignIn(_usernameController.text));

      userInputBloc.checkAddPostDetails(_titleController.text,
          _descriptionController.text, _imageController.text);

      showSnackBar();
      refreshPost();

      // scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
      //     content: const Text(
      //         'Congratz! You have successfully created a new post.')));

      // userInputBloc.checkSignIn(_usernameController.text);
      // scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
      //     content: const Text(
      //         'Congratz! You have successfully connected to the server.')));
      // // Navigator.push(
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
      SnackBar(content: const Text('You are disconnected from the server!'));
    }
  }

  @override
  Widget build(BuildContext context) {
    userInputBloc = BlocProvider.of<GetApiData>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Your Own Post'),
          centerTitle: true,
        ),
        body: BlocConsumer<GetApiData, ApiRequest>(
          listener: (context, state) {
            if (state is addPost && _checkController == true) {
              widget.besquare_API.sink.add(
                  '{"type": "create_post", "data": {"title": "${state.title}", "description": "${state.description}", "image": "${state.image}"}}');
            }
          },
          builder: (context, state) {
            return Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Image(
                          image: AssetImage('assets/add1.png'),
                          color: const Color.fromRGBO(255, 255, 255, 0.8),
                          colorBlendMode: BlendMode.modulate,
                          height: 120,
                          width: 120,
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 35,
                            right: 35,
                          ),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: TextFormField(
                                maxLength: 20,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  icon: Icon(IconData(58905,
                                      fontFamily: 'MaterialIcons')),
                                  labelText: 'Title',
                                  hintText: 'Enter your title...',
                                ),
                                controller: _titleController),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 35,
                            right: 35,
                          ),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: TextFormField(
                                maxLength: 20,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  icon: Icon(IconData(983753,
                                      fontFamily: 'MaterialIcons',
                                      matchTextDirection: true)),
                                  labelText: 'Description',
                                  hintText: 'Enter your description...',
                                ),
                                controller: _descriptionController),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 35,
                            right: 35,
                          ),
                          child: TextFormField(
                              maxLength: 200,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                icon: Icon(IconData(58562,
                                    fontFamily: 'MaterialIcons')),
                                labelText: 'Image',
                                hintText: 'Enter your image link...',
                              ),
                              controller: _imageController),
                        ),
                        ElevatedButton(
                          onPressed: !_checkController
                              ? null
                              : () {
                                  callAddPostBlocFunction();

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
                          child: Text('Create'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
