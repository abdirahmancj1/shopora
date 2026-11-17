import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/product_provider.dart';
import 'constants/app_colors.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        title: 'MiniShop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          textTheme: GoogleFonts.plusJakartaSansTextTheme(
            Theme.of(context).textTheme,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            secondary: AppColors.accent,
          ),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
