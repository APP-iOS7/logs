import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

import 'config/app_styles.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'screens/product_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey =
      'pk_test_51NDpRJJinXpHIPsErkhbbskGYZltQGnig4OTsxAuRcrWPXCNvyI6Dc8ApCNL4ciBQz1LhIT76fingitKdFTdjztU00zgfNNsgk';
  await Stripe.instance.applySettings();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: _buildTheme(),
        home: ProductListScreen(),
      ),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      primaryColor: AppColors.primary,
      // 색상 테마
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        surface: AppColors.background,
      ),
      scaffoldBackgroundColor: AppColors.cardBackground,
      // 텍스트 테마
      textTheme: TextTheme(
        displayLarge: AppTextStyles.heading1.copyWith(
          color: AppColors.textDark,
        ),
        displayMedium: AppTextStyles.heading2.copyWith(
          color: AppColors.textDark,
        ),
        displaySmall: AppTextStyles.heading3.copyWith(
          color: AppColors.textDark,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.textDark),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textDark,
        ),
        bodySmall: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textMedium,
        ),
        labelLarge: AppTextStyles.button.copyWith(color: Colors.white),
      ),
      // 앱바 테마
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation: 0,
        titleTextStyle: AppTextStyles.heading2.copyWith(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      // 카드 테마
      cardTheme: CardTheme(
        color: AppColors.cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      // 버튼 테마
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: AppTextStyles.button,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      // 입력 필드 테마
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.textLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
