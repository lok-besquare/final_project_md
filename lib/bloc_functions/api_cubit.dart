import 'package:final_project_md/bloc_functions/api_cubit_state.dart';
import 'package:final_project_md/favourite_list.dart';
import 'package:final_project_md/posts_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class GetApiData extends Cubit<ApiRequest> {
  GetApiData() : super(ValueNotEntered());
  final callAPI =
      WebSocketChannel.connect(Uri.parse('ws://besquare-demo.herokuapp.com'));
  // void passData(List<PostsData> data) {
  //   emit(StoreListData(data));
  // }
  void CheckIsValid() {
    emit(ValueEntered());
  }

  void CheckIsNotValid() {
    emit(ValueNotEntered());
  }

  void checkSignIn(String userNameInput) {
    // callAPI.sink.add(SignInRequest(
    // '{"type": "sign_in", "data": {"name": "$userNameInput"}}'));
    emit(SignInRequest(
        '{"type": "sign_in", "data": {"name": "$userNameInput"}}'));
  }

  void checkAddPostDetails(String title, String description, String image) {
    emit(addPost(title, description, image));
  }

  void passData(List<PostsData> postData) {
    print('STORE LIST DATA TRIGGER');
    emit(StoreListData(postData));
  }

  void passDetailsList(String title, String image, String description) {
    emit(StoreDetailsList(title, image, description));
  }

  void passFavList(List<favouriteList> data) {
    emit(StoreFavList(data));
  }

  void delPost(String id) {
    print('ARRIVE DLEETE EVENT');
    print(id);
    emit(deletePost('{"type": "delete_post", "data": {"postId": "$id"}}'));
  }
}
