import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/features/order/domain/repository/vendor_order_repository.dart';
import 'package:vtv_common/auth.dart';
import 'package:vtv_common/chat.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

import '../../features/chat/presentation/pages/vendor_chat_page.dart';
import '../../features/order/presentation/pages/vendor_order_detail_page.dart';
import '../../service_locator.dart';
import '../constants/global_variables.dart';

class VendorHandler {
  //! Order
  // static void updateOrderStatus(BuildContext context, String orderId, OrderStatus status) {
  static void updateOrderStatus(
    BuildContext context,
    String orderId,
    OrderStatus statusAfterUpdate,
    void Function() reloadCallback,
  ) async {
    String statusText(OrderStatus status) {
      switch (status) {
        case OrderStatus.PROCESSING:
          return 'Xác nhận đơn hàng này?';
        case OrderStatus.PICKUP_PENDING:
          return 'Xác nhận đơn hàng này đã sẵn sàng để giao?';
        case OrderStatus.CANCEL:
          return 'Xác nhận hủy đơn hàng này?';
        default:
          return 'Xác nhận ${status.name}';
      }
    }

    final isConfirm = await showDialogToConfirm(
      context: context,
      title: statusText(statusAfterUpdate),
      confirmText: 'Xác nhận',
      dismissText: 'Thoát',
    );

    if (!isConfirm) return;

    sl<VendorOrderRepository>().updateOrderStatus(orderId, statusAfterUpdate).then((respEither) {
      respEither.fold((error) => showDialogToAlert(context, title: Text(error.message ?? 'Lỗi khi chấp nhận đơn hàng')),
          (ok) {
        reloadCallback();
      });
    });
  }

  //# Open Message (Notification)
  /// Call this function on first screen
  static void openMessageOnTerminatedApp() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sl<FirebaseCloudMessagingManager>().runWhenContainInitialMessage(
        (remoteMessage) => processOpenRemoteMessage(remoteMessage),
      );
    });
  }

  static void processOpenRemoteMessage(RemoteMessage remoteMessage) {
    final currentUsername = GlobalVariables.navigatorState.currentContext?.read<AuthCubit>().state.currentUsername;
    if (currentUsername == null) return;

    if (remoteMessage.type == NotificationType.NEW_MESSAGE.name) {
      VendorHandler.navigateToChatPage(
        GlobalVariables.navigatorState.currentContext!,
        recipientUsername: currentUsername == remoteMessage.data['sender']
            ? remoteMessage.data['recipient'] // first message sent by vendor
            : remoteMessage.data['sender'], // first message sent by customer
      );
    } else if (remoteMessage.type == NotificationType.ORDER.name) {
      VendorHandler.navigateToOrderDetailPageViaRemoteMessage(remoteMessage);
    } else {
      VendorHandler.navigateToOrderDetailPageViaRemoteMessage(remoteMessage);
    }
  }

  //# Redirect
  static Future<void> navigateToChatPage(BuildContext context, {required String recipientUsername}) async {
    final room = await showDialogToPerform(
      context,
      dataCallback: () async {
        return await sl<ChatRepository>().getOrCreateChatRoom(recipientUsername).then((respEither) {
          return respEither.fold(
            (error) => null,
            (ok) => ok.data!,
          );
        });
      },
      closeBy: (context, result) => Navigator.of(context).pop(result),
    );

    if (room != null && context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VendorChatPage(room: room),
        ),
      );
    }
  }

  static Future<OrderDetailEntity?> navigateToOrderDetailPage(
    BuildContext context, {
    String? orderId,
    OrderDetailEntity? orderDetail,
  }) async {
    assert((orderDetail != null && orderId == null) || (orderDetail == null && orderId != null));

    if (orderId != null) {
      final respEither = await showDialogToPerform(
        context,
        dataCallback: () => sl<VendorOrderRepository>().getOrderDetail(orderId),
        closeBy: (context, result) => Navigator.of(context).pop(result),
      );
      if (!context.mounted || respEither == null) return null;

      final OrderDetailEntity? navigationOrder = respEither.fold(
        (error) => null, // Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra')
        (ok) => ok.data,
      );
      if (navigationOrder == null) return null; //! when load order detail failed >> no navigation

      return await Navigator.of(context).push<OrderDetailEntity>(
        MaterialPageRoute(builder: (context) => VendorOrderDetailPage(orderDetail: navigationOrder)),
      );
    } else if (orderDetail != null) {
      // no loading
      return await Navigator.of(context).push<OrderDetailEntity>(
        MaterialPageRoute(builder: (context) => VendorOrderDetailPage(orderDetail: orderDetail)),
      );
    } else {
      return null;
    }
  }

  static Future<OrderDetailEntity?> navigateToOrderDetailPageViaRemoteMessage(RemoteMessage? remoteMessage) async {
    if (remoteMessage?.notification?.body == null || GlobalVariables.navigatorState.currentContext == null) return null;

    final uuid = ConversionUtils.extractUUID(remoteMessage!.notification!.body!);
    if (uuid != null) {
      return navigateToOrderDetailPage(GlobalVariables.navigatorState.currentContext!, orderId: uuid);
    }
    return null;
  }
}
