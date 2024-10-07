import 'package:colorfactor/common/const/colors.dart';
import 'package:colorfactor/restaurant/model/restaurant_detail_model.dart';
import 'package:colorfactor/restaurant/model/restaurant_model.dart';
import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  //이미지
  final Widget image;
  //코트명
  final String name;
  //코트 태그
  final List<String> tags;
  //코트 평점 갯수
  final int ratingsCount;
  //거리
  final int distanceRange;
  //코트 비용
  final int courtFee;
  //평균 평점
  final double ratings;

  //상세카드 여부
  final bool isDetail;
//상세정보
  final String? detail;

  const RestaurantCard(
      {
      //이미지
      required this.image,
      //코트명
      required this.name,
      //코트 태그
      required this.tags,
      //코트 평점 갯수
      required this.ratingsCount,
      //거리
      required this.distanceRange,
      //코트 비용
      required this.courtFee,
      //평균 평점
      required this.ratings,

      this.isDetail = false,

        this.detail,

        super.key});

  factory RestaurantCard.fromModel({
    required RestaurantModel model,
    bool isDetail = false,
  }) {
    return RestaurantCard(
      image: Image.network(
        model.thumbUrl,
        fit: BoxFit.cover,
      ),
      name: model.name,
      tags: model.tags,
      ratingsCount: model.ratingsCount,
      distanceRange: model.deliveryTime,
      courtFee: model.deliveryFee,
      ratings: model.ratings,
      isDetail: isDetail,
      detail: model is RestaurantDetailModel ? model.detail : null,

    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            if(isDetail) image,
            if(!isDetail)
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                  width: MediaQuery.of(context).size.width, child: image),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isDetail? 16:0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    tags.join('  ·  '),
                    style: TextStyle(color: BODY_TEXT_COLOR, fontSize: 14),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      _IconText(
                          icon: Icons.star,
                          label:
                              ratings == 0 ? '아직 별점이 없습니다.' : ratings.toString()),
                      _IconText(
                          icon: Icons.numbers,
                          label: ratingsCount == 0
                              ? '첫 리뷰를 남겨주세요'
                              : '$ratingsCount개'.toString()),
                      renderDot(),
                      _IconText(
                          icon: Icons.pin_drop_outlined,
                          label: '거리 $distanceRange km'.toString()),
                      renderDot(),
                      _IconText(
                          icon: Icons.receipt_long_outlined,
                          label: courtFee.toString()),
                    ],
                  ),
                  if(detail != null && isDetail)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(detail!),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}

Widget renderDot() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4.0),
    child: Text(
      ' · ',
      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
    ),
  );
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String label;

  const _IconText({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: PRIMARY_ACTIVE_COLOR,
          size: 14,
        ),
        const SizedBox(
          width: 2,
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
