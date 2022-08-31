import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:licenta/models/user.dart';

class UserEndpoint {
  String hostname = "192.168.0.103:8080";

  Stream<bool> registerUser(String email, String password, String phone) {
    var url = Uri.http(hostname, '/api/auth/sign-up');
    Map<String, String> body = {
      'email': email,
      'username': email,
      'password': password,
      'number': phone,
    };
    return http
        .post(url, body: json.encode(body), headers: {
          "accept": "application/json",
          "content-type": "application/json"
        })
        .asStream()
        .map((response) {
          print('Response status: ${response.statusCode}');
          print('Response body: ${response.body}');
          return true;
        });
  }

  Stream<User> getUser(String email) {
    var url = Uri.http(hostname, '/api/users/info');
    return http
        .post(url, body: json.encode(email), headers: {
          "accept": "application/json",
          "content-type": "application/json"
        })
        .asStream()
        .map((response) {
          print('Response status: ${response.statusCode}');
          print('Response body: ${response.body}');
          Map<String, dynamic> map = jsonDecode(response.body);

          User user = User(
            phoneNumber: map["number"],
            email: map['email'],
            labels: map['description'],
          );
          return user;
        });
  }

  Stream<bool> loginUser(String email, String password) {
    var url = Uri.http(hostname, '/api/auth/sign-in');
    Map<String, String> body = {
      'username': email,
      'password': password,
    };

    return http
        .post(url, body: json.encode(body), headers: {
          "accept": "application/json",
          "content-type": "application/json"
        })
        .asStream()
        .map((response) {
          print('Response status: ${response.statusCode}');
          print('Response body: ${response.body}');
          return response.statusCode == 200;
        });
  }

  Stream<String> uploadPhotos(String email, List<Uint8List> photos) {
    var url = Uri.http(hostname, '/api/users/upload-photos');
    List<String> images = [];

    for (var element in photos) {
      images.add(base64.encode(element.toList()));
    }
    Map<String, dynamic> body = {
      'email': email,
      'photos': images,
    };

    return http
        .post(url, body: json.encode(body), headers: {
          "accept": "application/json",
          "content-type": "application/json"
        })
        .asStream()
        .map((response) {
          print('Response status: ${response.statusCode}');
          print('Response body: ${response.body}');
          return response.body;
        });
  }
}
