/// Food Store Table 객체 생성
class FoodStoreModel {
  final int? idx;

  final String? storeImgUrl;

  final double latitude;

  final double longitude;

  final String storeAddress;

  final String uid;

  final String storeName;

  final String storeComment;

  final DateTime? createdAt;

  FoodStoreModel({
    this.idx,
    this.storeImgUrl,
    required this.latitude,
    required this.longitude,
    required this.storeAddress,
    required this.uid,
    required this.storeName,
    required this.storeComment,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'store_img_url': storeImgUrl,
      'latitude': latitude,
      'longitude': longitude,
      'store_address': storeAddress,
      'uid': uid,
      'store_name': storeName,
      'store_comment': storeComment,
    };
  }

  factory FoodStoreModel.fromMap(Map<String, dynamic> data) {
    return FoodStoreModel(
      idx: data['idx'],
      storeImgUrl: data['store_img_url'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      storeAddress: data['store_address'],
      uid: data['uid'],
      storeName: data['store_name'],
      storeComment: data['store_comment'],
      createdAt: DateTime.parse(data['created_at']),
    );
  }
}
