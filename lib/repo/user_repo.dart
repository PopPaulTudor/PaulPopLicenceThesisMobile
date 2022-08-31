import 'dart:typed_data';

import 'package:licenta/endpoint/user_endpoint.dart';

import '../models/user.dart';

class UserRepo {
  final UserEndpoint _userProfileEndPoint = UserEndpoint();


  Stream<bool> registerUser(String email, String password, String phoneNumber){
    return _userProfileEndPoint.registerUser(email, password, phoneNumber);
  }

  Stream<bool> loginUser(String email, String password){
    return _userProfileEndPoint.loginUser(email, password);
  }

  Stream<String> uploadImages(String email, List<Uint8List> photos){
    return _userProfileEndPoint.uploadPhotos(email, photos);
  }
  Stream<User> getProfile(String email){
    return _userProfileEndPoint.getUser(email);

  }
}
