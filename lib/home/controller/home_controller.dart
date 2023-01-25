import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pinterest/home/model/pic_model.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../interceptor/dio_connectivity_request_retrier.dart';
import '../../interceptor/retry_interceptor.dart';

class HomeController extends GetxController {
  Rx<bool> offline = false.obs;
  Dio dio = Dio();
  bool once = false;
  Rx<bool> loading = false.obs;
  RxList<PicModel> myPics = <PicModel>[].obs;

  //checks the status of the connectivity
  checkConnectivity() async {
    Connectivity networkConnectivity = Connectivity();
    networkConnectivity.onConnectivityChanged.listen((event) async {
      try {
        final result = await InternetAddress.lookup('example.com');
        offline.value = !result.isNotEmpty && result[0].rawAddress.isNotEmpty;
        if (once == true) {
          Get.snackbar(
            'Back Online',
            "Display the message here",
            colorText: Colors.white,
            backgroundColor: Colors.lightBlue,
            icon: const Icon(Icons.add_alert),
          );
        }
      } on SocketException catch (_) {
        once = true;
        offline.value = true;
        Get.snackbar(
          'Offline',
          "You are offline",
          colorText: Colors.black,
          backgroundColor: Colors.pink[200],
          icon: const Icon(Icons.add_alert),
        );
      }
      print('status is $offline');
    });
  }

  //get data from the endpoint
  Future<void> getData() async {
    print('start getData');
    loading.value = true;
    List<PicModel> picsList = [];
    final response =
        await dio.get('http://jsonplaceholder.typicode.com/photos');

    if (response.statusCode == 200) {
      picsList =
          (response.data as List).map((x) => PicModel.fromJson(x)).toList();
      myPics.value = picsList;
    }
    loading.value = false;
    myPics.value = picsList;
  }

  initializeInterceptor() {
    dio.interceptors.add(
      RetryOnConnectionChangeInterceptor(
        requestRetrier: DioConnectivityRequestRetrier(
          dio: Dio(),
          connectivity: Connectivity(),
        ),
      ),
    );
  }
}
