import 'package:carousel_slider/carousel_slider.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:user_management_module/my_app.dart';

import '../data/drift/drift_database.dart';
import '../strings.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({Key? key}) : super(key: key);

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {

  @override
  void initState() {
    super.initState();
    fetchAllDownloads();
  }

  fetchAllDownloads() async{
    List<Download> data = await MyApp.db.getAllDownloads();
    print("Fetch all length");
    print(data.length);
  }

  @override
  Widget build(BuildContext context) {
    PageController controller =PageController(initialPage: 0);
    return SafeArea(
      child: StreamBuilder(
            stream: MyApp.db.watchAllDownloads(),
            builder: (context, AsyncSnapshot<List<Download>> snapshot) {
              final data = snapshot.data;
              print(data?.length);
              return (data != null && data.isNotEmpty) ?
              Stack(
                children: [
                  PageView.builder(
                    controller: controller,
                    itemCount: data.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return Image.memory(data[index].news);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35.0),
                            ),
                            child: SizedBox(
                              width: 35,
                              height: 35,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios_rounded,
                                  size: 19,
                                ),
                                color: Colors.black,
                                onPressed: () {
                                  Get.back();
                                },
                              ),
                            ),
                          )),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35.0),
                            ),
                            child: SizedBox(
                              width: 35,
                              height: 35,
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  size: 19,
                                  color: Theme.of(context).primaryColor,
                                ),
                                color: Colors.black,
                                onPressed: () async {
                                  await MyApp.db.deleteNews(data[controller.page!.toInt()]).then((value) =>
                                      Get.snackbar('News Deleted', '',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: Colors.red.shade100));
                                },
                              ),
                            ),
                          )),
                    ],
                  ),
                ],
              ) : Scaffold(
                appBar: AppBar(title: const Text("Downloads"),centerTitle: true,),
                body: Center(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.download, size: 100.h, color: Colors.grey,),
                        Text(Strings.noDownloads, style: TextStyle(
                            fontWeight: Theme.of(context).textTheme.headline5?.fontWeight,
                            fontSize: Theme.of(context).textTheme.headline5?.fontSize,
                            color: Colors.grey
                        ),)],
                    ),
                  ),
                ),
              );
            }
      ),
    );
  }
}
