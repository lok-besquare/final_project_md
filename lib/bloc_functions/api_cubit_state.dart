abstract class ApiRequest {}

class ValueNotEntered extends ApiRequest {}

class ValueEntered extends ApiRequest {}

class SignInRequest extends ApiRequest {
  late String userNameInput;

  SignInRequest(String input) {
    userNameInput = input;
  }
}

class addPost extends ApiRequest {
  late String title;
  late String description;
  late String image;

  addPost(String title, String description, String image) {
    this.title = title;
    this.description = description;
    this.image = image;
  }
}

class deletePost extends ApiRequest {
  late String id;

  deletePost(String id) {
    this.id = id;
  }
}

class StoreListData extends ApiRequest {
  late List postDataList;

  StoreListData(List data) {
    this.postDataList = data;
  }
}

class StoreDetailsList extends ApiRequest {
  late String title;
  late String image;
  late String description;
  StoreDetailsList(String title, String image, String description) {
    this.title = title;
    this.image = image;
    this.description = description;
  }
}

class StoreFavList extends ApiRequest {
  late List favList;

  StoreFavList(List data) {
    this.favList = data;
  }
}
