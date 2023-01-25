import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pinterest/home/controller/home_controller.dart';
import 'package:pinterest/interceptor/retry_interceptor.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../interceptor/dio_connectivity_request_retrier.dart';
import '../model/pic_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> imagesUrl = [
    "https://via.placeholder.com/600/d32776",
    "https://via.placeholder.com/600/d32776",
    "https://via.placeholder.com/600/d32776",
    "https://via.placeholder.com/600/d32776",
  ];
  late Dio dio;
  String string = '';
  late Future<List<PicModel>> myFuture;

  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    homeController.initializeInterceptor();
    homeController.checkConnectivity();
    homeController.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var mediaWidth = MediaQuery.of(context).size.width;
    var padding = MediaQuery.of(context).padding;
    var mediaHeight = height - padding.top - padding.bottom;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Container(
        margin: const EdgeInsets.only(left: 5, right: 5, top: 30),
        height: mediaHeight,
        width: mediaHeight,
        child: Column(
          children: [
            Obx(
              () => homeController.loading.value == true
                  ? const Expanded(
                      child: SizedBox(
                          height: 50,
                          width: 50,
                          child: Center(child: CircularProgressIndicator())),
                    )
                  : Expanded(
                      child: RefreshIndicator(
                        onRefresh: homeController.getData,
                        child: GridView.builder(
                          itemCount: homeController.myPics.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 5,
                                  crossAxisCount: 2),
                          itemBuilder: (context, index) {
                            return Container(
                                decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage(homeController
                                      .myPics.value[index].thumbnailUrl),
                                  fit: BoxFit.fill),
                            ));
                          },
                        ),
                      ),
                    ),
            ),

            // FutureBuilder(
            //     future: myFuture,
            //     //future: myFuture,
            //     builder: (context, snapshot) {
            //       if (snapshot.connectionState == ConnectionState.done) {
            //         if (snapshot.hasError) {
            //           print('error');
            //           return Expanded(
            //             child: Center(
            //               child: Text(
            //                 'Error: Unable to fetch the data',
            //                 style: TextStyle(color: Colors.white),
            //               ),
            //             ),
            //           );
            //         } else if (snapshot.hasData) {
            //           return Expanded(
            //             child: GridView.builder(
            //                 itemCount: imagesUrl.length,
            //                 gridDelegate:
            //                     SliverGridDelegateWithFixedCrossAxisCount(
            //                         crossAxisSpacing: 8,
            //                         mainAxisSpacing: 5,
            //                         crossAxisCount: 2),
            //                 itemBuilder: (context, index) {
            //                   return Container(
            //                       decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.circular(10),
            //                     image: DecorationImage(
            //                         image: NetworkImage(imagesUrl[index]),
            //                         fit: BoxFit.fill),
            //                   ));
            //                 }),
            //           );
            //         }
            //       }

            //       return CircularProgressIndicator();
            //     }),
            ElevatedButton(
                onPressed: () async {
                  // var res = await dio
                  //     .get("https://jsonplaceholder.typicode.com/photos");
                  // var data = res.data[0]['albumId'] as int;
                  // print('data is $data');
                  //_pullRefresh();
                  homeController.getData();
                },
                child: Text('Press me')),
          ],
        ),
      )),
    );
  }

  // Future<void> _pullRefresh() async {
  //   await Future.delayed(Duration(seconds: 3));
  //   List<PicModel> freshNumbers = await homeController.getData();
  //   setState(() {
  //     myFuture = Future.value(freshNumbers);
  //   });
  // }
}
