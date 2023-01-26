import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinterest/home/controller/home_controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    final mediaWidth = MediaQuery.of(context).size.width;
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
                            return CachedNetworkImage(
                              imageUrl:
                                  homeController.myPics[index].thumbnailUrl,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              //incase of error show erroe icon
                              errorWidget: (context, url, error) {
                                return const Icon(
                                  Icons.error,
                                  color: Colors.white,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
            ),
            //button to manually refresh
            ElevatedButton(
                onPressed: () async {
                  homeController.getData();
                },
                child: const Text('Refresh')),
          ],
        ),
      )),
    );
  }
}
