// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'model/product.dart';
import 'model/products_repository.dart';
import 'supplemental/product_search_delegate.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    required this.currentThemeMode,
    required this.onThemeModeChanged,
    Key? key,
  }) : super(key: key);

  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  List<Card> _buildGridCards(BuildContext context) {
    List<Product> products = ProductsRepository.loadProducts(Category.all);

    if (products.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());

    return products.map((product) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 11,
              child: Image.asset(
                product.assetName,
                package: product.assetPackage,
                fit: BoxFit.fitWidth,
              ),
            ),
            const SizedBox(height: 12.0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      product.name,
                      style: theme.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      formatter.format(product.price),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  IconData _iconForThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return Icons.brightness_auto;
      case ThemeMode.light:
        return Icons.wb_sunny_outlined;
      case ThemeMode.dark:
        return Icons.nightlight_round;
    }
  }

  String _labelForThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'Otomatis (Sistem)';
      case ThemeMode.light:
        return 'Terang';
      case ThemeMode.dark:
        return 'Gelap';
    }
  }

  Future<void> _showSearch(BuildContext context) async {
    final Product? selectedProduct = await showSearch<Product?>(
      context: context,
      delegate: ProductSearchDelegate(
        products: ProductsRepository.loadProducts(Category.all),
      ),
    );
    if (selectedProduct == null) {
      return;
    }
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      locale: Localizations.localeOf(context).toString(),
    );
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '${selectedProduct.name} • ${formatter.format(selectedProduct.price)}',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // TODO: Add a variable for Category (104)
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // TODO: Return an AsymmetricView (104)
    // TODO: Pass Category variable to AsymmetricView (104)
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            semanticLabel: 'menu',
          ),
          onPressed: () {},
        ),
        title: Text(
          'Abdi Setiawan Shop',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.search,
              semanticLabel: 'search',
            ),
            onPressed: () => _showSearch(context),
          ),
          PopupMenuButton<ThemeMode>(
            tooltip: 'Pilih tema',
            icon: Icon(
              _iconForThemeMode(currentThemeMode),
              semanticLabel: 'change theme',
            ),
            onSelected: onThemeModeChanged,
            itemBuilder: (BuildContext context) {
              return ThemeMode.values.map((ThemeMode mode) {
                final bool selected = mode == currentThemeMode;
                return PopupMenuItem<ThemeMode>(
                  value: mode,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        _iconForThemeMode(mode),
                        color: selected ? theme.colorScheme.primary : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _labelForThemeMode(mode),
                          style: selected
                              ? theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                )
                              : null,
                        ),
                      ),
                      if (selected)
                        Icon(
                          Icons.check,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                    ],
                  ),
                );
              }).toList();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.tune,
              semanticLabel: 'filter',
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        childAspectRatio: 8.0 / 9.0,
        children: _buildGridCards(context),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
