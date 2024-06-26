import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:vendor/features/product/domain/entities/dto/add_update_shop_category_request.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/shop.dart';

import '../../../../core/constants/vendor_api.dart';

abstract class VendorShopCategoryDataSource {
  //# category-shop-controller
  Future<SuccessResponse<List<ShopCategoryEntity>>> getAllShopCategories();
  Future<SuccessResponse<ShopCategoryEntity>> addProductsToCategoryShop(int categoryShopId, List<int> productIds);
  Future<SuccessResponse<ShopCategoryEntity>> removeProductsFromCategoryShop(int categoryShopId, List<int> productIds);

  Future<SuccessResponse<ShopCategoryEntity>> addShopCategory(AddUpdateShopCategoryRequest addParam);
  Future<SuccessResponse<ShopCategoryEntity>> updateShopCategory(
      int categoryShopId, AddUpdateShopCategoryRequest updateParam);

  Future<SuccessResponse> deleteShopCategory(int categoryShopId);
}

class VendorShopCategoryDataSourceImpl implements VendorShopCategoryDataSource {
  final Dio _dio;

  VendorShopCategoryDataSourceImpl(this._dio);

  @override
  Future<SuccessResponse<ShopCategoryEntity>> addProductsToCategoryShop(
      int categoryShopId, List<int> productIds) async {
    final url = uriBuilder(
      path: kAPICategoryShopAddProductURL,
      pathVariables: {'categoryShopId': categoryShopId.toString()},
    );

    final response = await _dio.putUri(url, data: json.encode(productIds));

    return handleDioResponse<ShopCategoryEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ShopCategoryEntity.fromMap(jsonMap['categoryShopDTO']),
    );
  }

  @override
  Future<SuccessResponse<List<ShopCategoryEntity>>> getAllShopCategories() async {
    final url = uriBuilder(path: kAPICategoryShopGetAllURL);

    final response = await _dio.getUri(url);

    return handleDioResponse<List<ShopCategoryEntity>, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => (jsonMap['categoryShopDTOs'] as List).map((e) => ShopCategoryEntity.fromMap(e)).toList(),
    );
  }

  @override
  Future<SuccessResponse<ShopCategoryEntity>> removeProductsFromCategoryShop(
      int categoryShopId, List<int> productIds) async {
    final url = uriBuilder(
      path: kAPICategoryShopDeleteProductURL,
      pathVariables: {'categoryShopId': categoryShopId.toString()},
    );

    final response = await _dio.deleteUri(url, data: json.encode(productIds));

    return handleDioResponse<ShopCategoryEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ShopCategoryEntity.fromMap(jsonMap['categoryShopDTO']),
    );
  }

  @override
  Future<SuccessResponse<ShopCategoryEntity>> addShopCategory(AddUpdateShopCategoryRequest addParam) async {
    final url = uriBuilder(path: kAPICategoryShopAddURL);

    final formData = FormData.fromMap(await addParam.toMultiPartFileMap());

    final response = await _dio.postUri(
      url,
      data: formData,
      options: Options(
        headers: {'Content-Type': 'multipart/form-data'},
      ),
    );

    return handleDioResponse<ShopCategoryEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ShopCategoryEntity.fromMap(jsonMap['categoryShopDTO']),
    );
  }

  @override
  Future<SuccessResponse<ShopCategoryEntity>> updateShopCategory(
      int categoryShopId, AddUpdateShopCategoryRequest updateParam) async {
    final url = uriBuilder(
      path: kAPICategoryShopUpdateURL,
      pathVariables: {'categoryShopId': categoryShopId.toString()},
    );

    final formData = FormData.fromMap(await updateParam.toMultiPartFileMap());

    final response = await _dio.putUri(
      url,
      data: formData,
      options: Options(
        headers: {'Content-Type': 'multipart/form-data'},
      ),
    );

    return handleDioResponse<ShopCategoryEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ShopCategoryEntity.fromMap(jsonMap['categoryShopDTO']),
    );
  }

  @override
  Future<SuccessResponse<Object?>> deleteShopCategory(int categoryShopId) async {
    final url = uriBuilder(
      path: kAPICategoryShopDeleteURL,
      pathVariables: {'categoryShopId': categoryShopId.toString()},
    );

    final response = await _dio.deleteUri(url);

    return handleDioResponse(
      response,
      url,
      hasData: false,
    );
  }
}
