import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

import 'package:authentication_app/models/company.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import '../../models/checkbox_model.dart';
import '../../models/company.dart';
import '../../services/dio_helper.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());
  static EditProfileCubit get(context) => BlocProvider.of(context);
  var imageFile;
  CompanyResponse? companyResponse;
  Company? company;

  addImage(pickedFile) {
    imageFile = pickedFile;
  }

  Future<void> editProfile(Company company) async {
    Map<String, dynamic> map = company.toJson();
    print("mapppp: $map , image = ${company.image!.path}");
    final queryParameters = Map<String, String>();
    for (final key in map.keys) {
      queryParameters[key] = map[key].toString();
    }
    var postUri =
        Uri.parse("http://10.0.2.2:8080/mobiletask/company/updateCompany.php");
    var request = http.MultipartRequest("POST", postUri);
    request.fields.addAll(queryParameters);
    if (company.image != null) {
      addImage(company.image);
      await company.image!.readAsBytes().then((value) => {
            request.files.add(http.MultipartFile.fromBytes(
              'image',
              value,
              filename: imageFile.path,
              contentType: MediaType('image', 'jpg'),
            ))
          });
    }
    print("\nrequest prepared..\n");
    emit(UpdateLoadingState());
    var res = await request.send().then((value) async {
      print("\nresponse recived ..\n$value");

      var message = await value.stream.bytesToString().then((value) {
        print("message :: ${value} ");
        Map<String, dynamic> val = json.decode(value);
        companyResponse = CompanyResponse.fromJson(val);
        print("valueMap : $val");
        if (companyResponse!.data!.companyId != null) {
          this.company = companyResponse!.data!;
          imageFile = this.company!.image;
          emit(UpdatedSuccessfullyState());
        } else
          emit(UpdatedFailedState());
      });
    });
  }
}
