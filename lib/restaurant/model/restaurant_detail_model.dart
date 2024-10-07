import 'package:colorfactor/common/utils/data_utils.dart';
import 'package:colorfactor/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_detail_model.g.dart';

///윗단계에 업체의 모델을 땡겨오고
///
@JsonSerializable()
class RestaurantDetailModel extends RestaurantModel {
  ///추가되는 팩터
  final String detail;

  ///상세페이제엇 추가되는 리스트 다시 모델화하여 올려온것
  ///json에서 자동으로 받아올때 이 안에 또 컨스트럭터가 있다면
  ///추가로 받아올 기능이 있다.
  ///
  final List<RestaurantProductModel> products;


  ///추가되는 것들만 this.으로 다시 명시해준다
  RestaurantDetailModel({
    required super.id,
    required super.name,
    required super.thumbUrl,
    required super.tags,
    required super.priceRange,
    required super.ratings,
    required super.ratingsCount,
    required super.deliveryTime,
    required super.deliveryFee,
    required this.detail,
    required this.products,
  });

  factory RestaurantDetailModel.fromJson(Map<String, dynamic> json)
  => _$RestaurantDetailModelFromJson(json);


  // factory RestaurantDetailModel.fromJson({
  //   required Map<String, dynamic> json,
  // }) {
  //   return RestaurantDetailModel(
  //     id: json['id'],
  //     name: json['name'],
  //     thumbUrl: 'http://$ip${json['thumbUrl']}',
  //     tags: List<String>.from(json['tags']),
  //     priceRange: RestaurantPriceRange.values.firstWhere(
  //       (e) => e.name == json['priceRange'],
  //     ),
  //     ratings: json['ratings'],
  //     ratingsCount: json['ratingsCount'],
  //     deliveryTime: json['deliveryTime'],
  //     deliveryFee: json['deliveryFee'],
  //     detail: json['detail'],
  //     products: json['products'].map<RestaurantProductModel>(
  //       (x) => RestaurantProductModel.fromJson(
  //         json: x,
  //       ),
  //     ).toList(),
  //
  //   );
  // }
}

///데이터 안에 리스트가 들어있는 것은 또 따로 모델을 만들어서 위로 올려보낸다
@JsonSerializable()
class RestaurantProductModel {
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String imgUrl;
  final String detail;
  final int price;

  RestaurantProductModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
  });

  factory RestaurantProductModel.fromJson(Map<String, dynamic> json)
  => _$RestaurantProductModelFromJson(json);


}