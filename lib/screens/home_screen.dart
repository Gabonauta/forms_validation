import 'package:flutter/material.dart';
import 'package:forms_validation/models/models.dart';
import 'package:forms_validation/screens/screens.dart';
import 'package:forms_validation/services/services.dart';
import 'package:forms_validation/widgets/product_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    if (productsService.isLoading) return LoadingScreen();
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        leading: IconButton(
            onPressed: () async {
              authService.logout();
              Navigator.pushReplacementNamed(context, 'login');
            },
            icon: Icon(Icons.login_outlined)),
      ),
      body: ListView.builder(
        itemCount: productsService.products.length,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          onTap: () {
            productsService.selectedProduct =
                productsService.products[index].copy();
            Navigator.pushNamed(context, 'product');
          },
          child: ProductCard(
            product: productsService.products[index],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          productsService.selectedProduct =
              new Product(available: false, name: '', price: 0.0);
          Navigator.pushNamed(context, 'product');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
