import 'dart:async';

import 'package:fake_store_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../models/cart_item.dart';

class PaymentService {
  Future<Map<String, dynamic>> processPayment({
    required double amount,
    required Map<String, String> shippingAddress,
    required List<CartItem> items,
  }) async {
    try {
      final clientSecret = await ApiService().createPaymentIntent();
      debugPrint('clientSecret: $clientSecret');
      // Stripe 결제 시트 초기화
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: '내 커머스 앱',
          style: ThemeMode.light,
          billingDetails: BillingDetails(
            name: shippingAddress['name'],
            phone: shippingAddress['phone'],
            email: shippingAddress['email'],
            address: Address(
              city: shippingAddress['city'],
              country: 'KR', // 대한민국
              line1: shippingAddress['address'],
              line2: shippingAddress['address2'],
              postalCode: shippingAddress['zipCode'],
              state: shippingAddress['state'],
            ),
          ),
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(primary: Colors.blue),
          ),
        ),
      );

      // 결제 시트 표시 및 결제 처리
      await Stripe.instance.presentPaymentSheet();

      // 결제 성공 (실제로는 서버에서 확인하는 단계 필요)
      final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
      return {
        'success': true,
        'orderId': orderId,
        'amount': amount,
        'date': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      if (e is StripeException) {
        // 사용자가 결제 취소 또는 Stripe 오류 발생
        return {
          'success': false,
          'error': '결제가 취소되었습니다: ${e.error.localizedMessage}',
        };
      } else {
        // 기타 오류
        return {'success': false, 'error': '결제 중 오류가 발생했습니다: $e'};
      }
    }
  }

  Future<Map<String, dynamic>> processDummyPayment({
    required double amount,
    required String paymentMethod,
    required Map<String, String> shippingAddress,
    required List<CartItem> items,
  }) async {
    return {'status': 'success', 'message': 'Payment was successful'};
  }

  Future<Map<String, dynamic>> getDummyOrderStatus(String orderId) async {
    // 주문 상태 확인 로직
    await Future.delayed(const Duration(seconds: 1));
    return {'status': 'success', 'message': 'Order is being processed'};
  }
}
