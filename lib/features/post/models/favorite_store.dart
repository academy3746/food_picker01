/// Favorite Store Table 객체 생성
class FavoriteModel {
  final int? idx;

  final int foodStoreIdx;

  final String favoriteUid;

  final DateTime? createdAt;

  FavoriteModel({
    this.idx,
    required this.foodStoreIdx,
    required this.favoriteUid,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'food_store_idx': foodStoreIdx,
      'favorite_uid': favoriteUid,
    };
  }

  factory FavoriteModel.fromMap(Map<String, dynamic> data) {
    return FavoriteModel(
      idx: data['idx'],
      foodStoreIdx: data['food_store_idx'],
      favoriteUid: data['favorite_uid'],
      createdAt: DateTime.parse(data['created_at']),
    );
  }
}
