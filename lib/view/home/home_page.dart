import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mulai_flutter/config/config.dart';
import 'package:mulai_flutter/view/home/home_controller.dart';
import 'package:mulai_flutter/model/film_model.dart';
import 'package:mulai_flutter/services/get_film.dart';
import 'package:mulai_flutter/theme.dart';
import 'package:mulai_flutter/view/home/widget/row_film.dart';

class HomePage extends GetView<HomeController> {
  String namaUser;
  HomePage({super.key, required this.namaUser});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(initState: (state) {
      controller.getFilm();
    }, builder: (context) {
      return Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Obx(
              () => Column(
                children: [
                  _appBar(),
                  _slideImage(),
                  _indicator(),
                  _rowFilm('Top Rated', controller.listOfTopRatedFilm),
                  _rowFilm('Popular Film', controller.listOfPopularFilm),
                  // _rowFilm('Rick and Morthy', listOfPopularFilm),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  _rowFilm(String title, List<FilmModel> list) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'See all',
                style: TextStyle(
                  color: mainColor,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < list.length; i++)
                  RowFilm(
                    filmModel: list[i],
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _indicator() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < controller.listOfPopularFilm.length; i++)
            i == controller.currentIndex
                ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    width: 24,
                    height: 8,
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),

          // ...listOfColor.map(
          //   (e) {
          //     return Container(
          //       margin: EdgeInsets.symmetric(horizontal: 2),
          //       width: 24,
          //       height: 8,
          //       decoration: BoxDecoration(
          //         color: mainColor,
          //         borderRadius: BorderRadius.circular(15),
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

  _slideImage() {
    return controller.isLoading.value
        ? Container(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(
                color: mainColor,
              ),
            ),
          )
        : Container(
            height: 200,
            child: PageView.builder(
              onPageChanged: (value) {
                var realIndex = value % controller.listOfPopularFilm.length;

                controller.currentIndex.value = realIndex;
              },
              itemBuilder: (context, index) {
                print("Index : $index");
                // var realIndex = index % listOfPopularFilm.length;
                // print("Real Index: $realIndex");

                return Stack(
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: NetworkImage(
                            '${baseImageUrl}original/${controller.listOfPopularFilm[index].backdropPath ?? ''}',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: 200,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            mainColor,
                            mainColor.withOpacity(0.9),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${controller.listOfPopularFilm[index].title}',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            controller.listOfPopularFilm[index].overview ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xffCCC8F5),
                              // fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                          Spacer(),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              'Watch Now',
                              style: TextStyle(
                                color: mainColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            ));
  }

  _appBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 30),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 25,
            backgroundImage: NetworkImage(
              'https://artriva.com/media/k2/galleries/20/d.jpg',
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Hi, ${namaUser}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  'Let\'s watch a movie',
                  style: TextStyle(fontSize: 12, color: Color(0xff8C8E98)),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            child: Image.asset('assets/icons/ic_search.png'),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {},
            child: Icon(
              Icons.notifications_none_outlined,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}
