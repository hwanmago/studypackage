import 'dart:async';
import 'package:colorfactor/common/const/data.dart';
import 'package:colorfactor/common/layout/default_layout.dart';
import 'package:colorfactor/dio/dio.dart';
import 'package:colorfactor/product/component/product_card.dart';
import 'package:colorfactor/restaurant/component/RestaurantCard.dart';
import 'package:colorfactor/restaurant/model/restaurant_detail_model.dart';
import 'package:colorfactor/restaurant/repository/restaurant_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id;

  const RestaurantDetailScreen({super.key, required this.id});

  ///api 요청
  Future<RestaurantDetailModel> getRestaurantDetail() async {
    final dio = Dio();
///인터셉터로 상태값 관리 받기
    dio.interceptors.add(
      CustomInterceptor(
        storage: storage,
      ),
    );

    final respository =
        RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');

    return respository.getRestaurantDetail(id: id);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '불타는 덕볶이',
      child: FutureBuilder<RestaurantDetailModel>(
          future: getRestaurantDetail(),
          builder: (_, AsyncSnapshot<RestaurantDetailModel> snapshot) {
           if(snapshot.hasError){
             return Text(snapshot.error.toString());
           }

            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return CustomScrollView(
              slivers: [
                renderTop(
                  model: snapshot.data!,
                ),
                renderLabel(),
                renderProducts(products: snapshot.data!.products),
              ],
            );
          }),
    );
  }

  SliverPadding renderLabel() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  renderProducts({required List<RestaurantProductModel> products}) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final model = products[index];
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ProductCard.fromModel(
                model: model,
              ),
            );
          },
          childCount: 9,
        ),
      ),
    );
  }

  SliverToBoxAdapter renderTop({
    required RestaurantDetailModel model,
  }) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }
}
