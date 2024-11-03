import 'package:flutter/material.dart';
import 'package:product_widget/product_widget/bloc/home_bloc.dart';
import 'package:product_widget/product_widget/pages/all_products_widget_v2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatelessWidget {
  const DemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Button usage demo'),
      ),
      body: BlocProvider(
        create: (_) => sl<HomeBloc>(), // Provides HomeBloc to AllProductsWidgetV2
        child: AllProductsWidgetV2(),
      ),
    );
  }
}
