import 'package:flutter/material.dart';
import 'package:product_widget/product_widget/bloc/product_widget_bloc.dart';
import 'package:product_widget/product_widget/pages/all_products_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Theme/style.dart';
import 'Theme/theme_values.dart';
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: darkTheme,/// Set the dark theme using the predefined darkTheme
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatelessWidget {
  const DemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => sl<ProductWidgetBloc>(), // Provides HomeBloc to AllProductsWidgetV2
        child: Container(
            decoration: backgroundBoxDecoration,
            child: SafeArea(child: AllProductsWidget())),
      ),
    );
  }
}
