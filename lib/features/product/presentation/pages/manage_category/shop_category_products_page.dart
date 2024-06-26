import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/guest.dart';
import 'package:vtv_common/shop.dart';

import '../../../../../service_locator.dart';
import '../../../domain/repository/vendor_product_repository.dart';
import '../../components/product_of_shop_category_item.dart';
import 'product_shop_picker_page.dart';

// this page is used to manage(add/remove) products of a shop category
class ShopCategoryProductsPage extends StatefulWidget {
  const ShopCategoryProductsPage({super.key, required this.shopCategory});

  final ShopCategoryEntity shopCategory;

  @override
  State<ShopCategoryProductsPage> createState() => _ShopCategoryProductsPageState();
}

class _ShopCategoryProductsPageState extends State<ShopCategoryProductsPage> {
  bool _isLoading = false;
  bool _isSelecting = false;

  void showLoading() => {if (mounted) setState(() => _isLoading = true)};
  void hideLoading() => {if (mounted) setState(() => _isLoading = false)};
  ShopCategoryEntity? _shopCategory;

  List<int> selectedProductIds = [];

  void loadData() async {
    showLoading();
    _shopCategory =
        await sl<GuestRepository>().getCategoryShopByCategoryShopId(widget.shopCategory.categoryShopId).then(
              (respEither) => respEither.fold(
                (error) => null,
                (ok) => ok.data!,
              ),
            );
    hideLoading();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(widget.shopCategory.name),
              actions: _isSelecting
                  ? [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final isConfirmDelete = await showDialogToConfirm(
                            context: context,
                            title: 'Xác nhận xóa sản phẩm',
                            content: 'Bạn có chắc chắn muốn xóa sản phẩm khỏi danh mục?',
                          );
                          if (isConfirmDelete == null || !isConfirmDelete) return;

                          final respEither = await sl<VendorProductRepository>().removeProductsFromCategoryShop(
                            widget.shopCategory.categoryShopId,
                            selectedProductIds,
                          );

                          respEither.fold(
                            (error) =>
                                Fluttertoast.showToast(msg: error.message ?? 'Xóa sản phẩm khỏi danh mục thất bại'),
                            (ok) => setState(() {
                              _shopCategory = ok.data!;
                              selectedProductIds.clear();
                              _isSelecting = false;
                            }),
                          );
                        },
                      ),
                    ]
                  : null,
              leading: _isSelecting
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          _isSelecting = false;
                          selectedProductIds.clear();
                        });
                      },
                    )
                  : null,
            ),
            floatingActionButton: _isSelecting
                ? null
                : FloatingActionButton(
                    onPressed: () async {
                      //! Add product to shop category
                      final List<int>? productIds = await Navigator.of(context).push<List<int>>(MaterialPageRoute(
                        builder: (context) => ProductShopPickerPage(
                          excludeProductIds: _shopCategory!.products?.map((e) => e.productId).toList(),
                        ),
                      ));

                      if (productIds != null && productIds.isNotEmpty) {
                        final respEither = await sl<VendorProductRepository>().addProductsToCategoryShop(
                          widget.shopCategory.categoryShopId,
                          productIds,
                        );

                        respEither.fold(
                          (error) =>
                              Fluttertoast.showToast(msg: error.message ?? 'Thêm sản phẩm vào danh mục thất bại'),
                          (ok) => setState(() {
                            _shopCategory = ok.data!;
                          }),
                        );
                      }
                    },
                    child: const Icon(Icons.add),
                  ),
            body: _shopCategory!.products!.isEmpty
                ? const MessageScreen(message: 'Không có sản phẩm nào trong danh mục này')
                : buildListProduct(),
          );
  }

  ListView buildListProduct() {
    return ListView.builder(
      itemCount: _shopCategory!.products!.length,
      itemBuilder: (context, index) {
        final product = _shopCategory!.products![index];
        return Row(
          children: [
            _isSelecting
                ? Checkbox(
                    value: selectedProductIds.contains(product.productId),
                    onChanged: (value) {
                      if (value!) {
                        selectedProductIds.add(product.productId);
                      } else {
                        selectedProductIds.remove(product.productId);
                      }
                      setState(() {});
                    },
                  )
                : const SizedBox.shrink(),
            Expanded(
              child: ProductOfShopCategoryItem(
                product: product,
                onLongPress: () {
                  setState(() {
                    _isSelecting = !_isSelecting;
                    selectedProductIds.clear();
                    selectedProductIds.add(product.productId);
                  });
                },
                onPressed: _isSelecting
                    ? () {
                        setState(() {
                          if (selectedProductIds.contains(product.productId)) {
                            selectedProductIds.remove(product.productId);
                          } else {
                            selectedProductIds.add(product.productId);
                          }
                        });
                      }
                    : null,
              ),
            ),
          ],
        );
      },
    );
  }
}
