// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:vtv_common/core.dart';
import 'package:vtv_common/shop.dart';

class ShopRegisterUpdateRequest {
  final String name;
  final String address;
  final String provinceName;
  final String districtName;
  final String wardName;
  final String wardCode;
  final String phone;
  final String email;
  final String avatar;
  final bool changeAvatar;
  final String description;
  // final DateTime openTime;
  final String openTime;
  // final DateTime closeTime;
  final String closeTime;

  ShopRegisterUpdateRequest({
    required this.name,
    required this.address,
    required this.provinceName,
    required this.districtName,
    required this.wardName,
    required this.wardCode,
    required this.phone,
    required this.email,
    required this.avatar,
    required this.changeAvatar,
    required this.description,
    required this.openTime,
    required this.closeTime,
  });

  factory ShopRegisterUpdateRequest.fromShop(ShopEntity shop) {
    return ShopRegisterUpdateRequest(
      name: shop.name,
      address: shop.address,
      provinceName: shop.provinceName,
      districtName: shop.districtName,
      wardName: shop.wardName,
      wardCode: shop.wardCode,
      phone: shop.phone,
      email: shop.email,
      avatar: shop.avatar,
      changeAvatar: false,
      description: shop.description,
      openTime: shop.openTime,
      closeTime: shop.closeTime,
    );
  }

  ShopRegisterUpdateRequest copyWith({
    String? name,
    String? address,
    String? provinceName,
    String? districtName,
    String? wardName,
    String? wardCode,
    String? phone,
    String? email,
    String? avatar,
    bool? changeAvatar,
    String? description,
    String? openTime,
    String? closeTime,
  }) {
    return ShopRegisterUpdateRequest(
      name: name ?? this.name,
      address: address ?? this.address,
      provinceName: provinceName ?? this.provinceName,
      districtName: districtName ?? this.districtName,
      wardName: wardName ?? this.wardName,
      wardCode: wardCode ?? this.wardCode,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      changeAvatar: changeAvatar ?? this.changeAvatar,
      description: description ?? this.description,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
    );
  }

  Future<Map<String, dynamic>> toMap() async {
    return <String, dynamic>{
      'name': name,
      'address': address,
      'provinceName': provinceName,
      'districtName': districtName,
      'wardName': wardName,
      'wardCode': wardCode,
      'phone': phone,
      'email': email,
      // 'avatar': avatar,
      if (changeAvatar) 'avatar': await FileUtils.getMultiPartFileViaPath(avatar),
      'changeAvatar': changeAvatar,
      'description': description,
      'openTime': openTime,
      'closeTime': closeTime,
    };
  }

  // factory VendorRegisterParam.fromMap(Map<String, dynamic> map) {
  //   return VendorRegisterParam(
  //     name: map['name'] as String,
  //     address: map['address'] as String,
  //     provinceName: map['provinceName'] as String,
  //     districtName: map['districtName'] as String,
  //     wardName: map['wardName'] as String,
  //     wardCode: map['wardCode'] as String,
  //     phone: map['phone'] as String,
  //     email: map['email'] as String,
  //     avatar: map['avatar'] as String,
  //     changeAvatar: map['changeAvatar'] as bool,
  //     description: map['description'] as String,
  //     openTime: DateTime.fromMillisecondsSinceEpoch(map['openTime'] as int),
  //     closeTime: DateTime.fromMillisecondsSinceEpoch(map['closeTime'] as int),
  //   );
  // }

  String toJson() => json.encode(toMap());

  // factory VendorRegisterParam.fromJson(String source) =>
  //     VendorRegisterParam.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VendorRegisterParam(name: $name, address: $address, provinceName: $provinceName, districtName: $districtName, wardName: $wardName, wardCode: $wardCode, phone: $phone, email: $email, avatar: $avatar, changeAvatar: $changeAvatar, description: $description, openTime: $openTime, closeTime: $closeTime)';
  }

  @override
  bool operator ==(covariant ShopRegisterUpdateRequest other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.address == address &&
        other.provinceName == provinceName &&
        other.districtName == districtName &&
        other.wardName == wardName &&
        other.wardCode == wardCode &&
        other.phone == phone &&
        other.email == email &&
        other.avatar == avatar &&
        other.changeAvatar == changeAvatar &&
        other.description == description &&
        other.openTime == openTime &&
        other.closeTime == closeTime;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        address.hashCode ^
        provinceName.hashCode ^
        districtName.hashCode ^
        wardName.hashCode ^
        wardCode.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        avatar.hashCode ^
        changeAvatar.hashCode ^
        description.hashCode ^
        openTime.hashCode ^
        closeTime.hashCode;
  }
}
