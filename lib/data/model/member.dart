/// Member Table 객체 생성
class MemberModel {
  final int? idx;

  final String name;

  final String email;

  final String introduce;

  final String? profileUrl;

  final String uid;

  final DateTime? createdAt;

  MemberModel({
    this.idx,
    required this.name,
    required this.email,
    required this.introduce,
    this.profileUrl,
    required this.uid,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'introduce': introduce,
      'profile_url': profileUrl,
      'uid': uid,
    };
  }

  factory MemberModel.fromMap(Map<String, dynamic> data) {
    return MemberModel(
      idx: data['idx'],
      name: data['name'],
      email: data['email'],
      introduce: data['introduce'],
      profileUrl: data['profile_url'],
      uid: data['uid'],
      createdAt: DateTime.parse(data['created_at']),
    );
  }
}
