import 'dart:convert';

import 'package:abwab_elkheir_dashboard/Constants/Endpoints.dart';
import 'package:abwab_elkheir_dashboard/Services/HTTPException.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'dart:typed_data';

import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

class WebServices {
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      final response = await Dio().post(
        Endpoints.baseUrl + Endpoints.signin,
        data: json.encode(
          {
            "email": email,
            "password": password,
          },
        ),
        options: Options(
          validateStatus: (_) {
            return true;
          },
        ),
      );

      if (response.statusCode != 200) {
        throw HTTPException(response.data['message']).toString();
      }
      return response.data;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<Map<String, dynamic>> addCase(
      String title,
      String description,
      int totalPrice,
      List<String> images,
      bool isActive,
      String status,
      String category) async {
    try {
      print('Adding web');
      final response = await Dio().post(
        Endpoints.baseUrl + Endpoints.addCase,
        data: json.encode(
          {
            "title": title,
            "description": description,
            "totalPrice": totalPrice,
            "images": images,
            "isActive": isActive,
            "status": status,
            "category": ''
          },
        ),
        options: Options(
          validateStatus: (_) {
            return true;
          },
        ),
      );

      print(response.data);

      if (response.statusCode != 200) {
        throw HTTPException(response.data['message']).toString();
      }
      return response.data;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<Map<String, dynamic>> getImagesUrls(
    PickedFile image,
    String token,
  ) async {
    try {
      var stream = new http.ByteStream(image.openRead());
      stream.cast();

      var uri = Uri.parse(Endpoints.baseUrl + Endpoints.getImageUrls);
      Uint8List imageBytes = await image.readAsBytes();
      int length = imageBytes.length;
      var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile('files', stream, length,
          filename: basename(image.path),
          contentType: MediaType('image', 'png'));

      request.files.add(multipartFile);
      var response = await request.send();
      print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });

      // final response = await Dio().post(
      //   Endpoints.baseUrl + Endpoints.getImageUrls,
      //   data: formData,
      //   options: Options(
      //     //contentType: "application/json",
      //     validateStatus: (_) {
      //       return true;
      //     },
      //     headers: {
      //       "Authorization": "Bearer " + token,
      //     },
      //   ),
      // );

      // if (response.statusCode != 200) {
      //   throw HTTPException(response.data['message']).toString();
      // }
      // return response.data;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<Map<String, dynamic>> editCase(
      String id,
      String title,
      String description,
      int totalPrice,
      List<String> images,
      bool isActive,
      String status,
      String category,
      String token) async {
    try {
      print('Editing');
      final response = await Dio().post(
        Endpoints.baseUrl + Endpoints.editCase,
        data: json.encode(
          {
            "_id": id,
            "title": title,
            "description": description,
            "totalPrice": totalPrice,
            "images": images,
            "isActive": isActive,
            "status": status,
            "category": category
          },
        ),
        options: Options(
          headers: {
            "Authorization": "Bearer " + token,
          },
          validateStatus: (_) {
            return true;
          },
        ),
      );

      print(response.data);

      if (response.statusCode != 200) {
        throw HTTPException(response.data['message']).toString();
      }
      return response.data;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<Map<String, dynamic>> fetchCases(
      String status, String startDate, String endDate) async {
    try {
      final response = await Dio().get(
        Endpoints.baseUrl + Endpoints.cases,
        queryParameters: {
          "status": status,
          "startDate": startDate,
          "endDate": endDate,
        },
      );

      Map<String, dynamic> results;

      if (response.statusCode == 200) {
        results = {
          "statusCode": 200,
          // "data": jsonDecode(response.data),
          "data": response.data,
        };
      } else if (response.statusCode == 400) {
        results = {
          "statusCode": 400,
          "data": "Something went wrong",
        };
      } else if (response.statusCode == 404) {
        results = {
          "statusCode": 400,
          "data": "Something went wrong",
        };
      }
      return results;
    } catch (error) {
      return {
        "statusCode": 400,
        "data": "Something went wrong",
      };
    }
  }
}
