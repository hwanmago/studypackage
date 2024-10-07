import 'package:colorfactor/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_model.g.dart';
///flutter pub run build_runner build 실행어로 클래스에 대한 파트 파일 실행

///모델 안에는 키 값들을 모두 들고있으면됨
enum RestaurantPriceRange{
  expensive, medium, cheap
}

@JsonSerializable()
///Json Serialize 태그를 달고 실행해서 -> 모델과 Json파일을 자동으로 맵핑한다
class RestaurantModel{
  final String id;
  final String name;
/// Json에서 자동으로 가져오지만, thumbUrl앞에 ip주소와 웹주소를 넣어줘야 하기 떄문에 여기서는 이렇게 처리 할 수 있다.
  @JsonKey(
    ///fromJson이 실행이 되어 가져올때는 fromJson에다.
    ///맨 아레 Static으로 (고정값)으로 thumbUrl을 변환할 값을 생성한다.
    fromJson: DataUtils.pathToUrl,
    ///toJson이 실행이 되어 보낼때는 toJson에다
    // toJson: ,
  )
  final String thumbUrl;
  final List<String>tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.priceRange,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,


});

///그리고 .g.dart파일에서 다시 factory 컨스트럭터로 불러온다
///레스토랑 모델은 Json파일에서 불러올것이고 (.g.dart에서) 이 방식은
///레스토랑모델 제이슨파일에서 - 괄호안에 (json)은 어디서 오는가?
/// 괄호 안에 json은 .fromJson에서 Map<String, dynamic> json에서 오고있다.
  factory RestaurantModel.fromJson(Map<String, dynamic>json)
  => _$RestaurantModelFromJson(json);

///다시 json파일로 변환해서 보내주는 방식이다
  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);

  ///fromJson에서 변환해줘야 하는 thumbUrl을
  ///고정 값인 static으로 $ip로 주소를 불러주고
  ///$value는 변동값인 url로 받아준다
  ///data_utils.dart로 이동시켜 묵어준다
  // static pathToUrl(String value){
  //   return 'http://$ip$value';
  // }
  
//   factory RestaurantModel.fromJson({
//     required Map<String, dynamic> json,
// }){
//     return RestaurantModel(
//         id: json['id'],
//         name: json['name'],
//         thumbUrl: 'http://$ip${json['thumbUrl']}',
//         tags: List<String>.from(json['tags']),
//     priceRange: RestaurantPriceRange.values.firstWhere((e)=> e.name ==json['priceRange']),
//     ratings: json['ratings'],
//     ratingsCount: json['ratingsCount'],
//     deliveryTime: json['deliveryTime'],
//     deliveryFee: json['deliveryFee'],
//     );
//   }

}