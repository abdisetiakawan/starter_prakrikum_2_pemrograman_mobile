import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/product.dart';

class ProductSearchDelegate extends SearchDelegate<Product?> {
  ProductSearchDelegate({required this.products});

  final List<Product> products;

  @override
  String? get searchFieldLabel => 'Cari produk';

  @override
  List<Widget>? buildActions(BuildContext context) {
    if (query.isEmpty) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => close(context, null),
          tooltip: 'Tutup pencarian',
        ),
      ];
    }
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
        tooltip: 'Hapus kata kunci',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
      tooltip: 'Kembali',
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Product> matches = _filterProducts(query);
    if (matches.isEmpty) {
      return _buildEmptyState(
        context,
        icon: Icons.search_off,
        message: 'Tidak ada produk yang cocok',
      );
    }
    return _buildProductList(context, matches);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Product> suggestions = query.isEmpty
        ? products.where((Product product) => product.isFeatured).toList()
        : _filterProducts(query);

    if (suggestions.isEmpty) {
      return _buildEmptyState(
        context,
        icon: Icons.lightbulb_outline,
        message: query.isEmpty
            ? 'Mulai ketik untuk mencari produk'
            : 'Tidak ada saran',
      );
    }
    return _buildProductList(context, suggestions);
  }

  List<Product> _filterProducts(String value) {
    final String trimmed = value.trim().toLowerCase();
    if (trimmed.isEmpty) {
      return <Product>[];
    }
    return products.where((Product product) {
      return product.name.toLowerCase().contains(trimmed);
    }).toList();
  }

  Widget _buildProductList(BuildContext context, List<Product> items) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      locale: Localizations.localeOf(context).toString(),
    );
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (BuildContext context, int index) {
        final Product product = items[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              product.assetName,
              package: product.assetPackage,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
          ),
          title: _HighlightedText(
            fullText: product.name,
            query: query,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            _categoryLabel(product.category),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: Text(
            formatter.format(product.price),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
          onTap: () => close(context, product),
        );
      },
    );
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String message,
  }) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            icon,
            size: 48,
            color: theme.colorScheme.primary.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _categoryLabel(Category category) {
    switch (category) {
      case Category.accessories:
        return 'Aksesori';
      case Category.clothing:
        return 'Pakaian';
      case Category.home:
        return 'Dekorasi Rumah';
      case Category.all:
        return 'Semua';
    }
  }
}

class _HighlightedText extends StatelessWidget {
  const _HighlightedText({
    required this.fullText,
    required this.query,
    this.style,
  });

  final String fullText;
  final String query;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(fullText, style: style);
    }
    final String lowerFull = fullText.toLowerCase();
    final String lowerQuery = query.toLowerCase();
    final int matchIndex = lowerFull.indexOf(lowerQuery);
    if (matchIndex == -1) {
      return Text(fullText, style: style);
    }
    final int matchEnd = matchIndex + lowerQuery.length;
    return RichText(
      text: TextSpan(
        style: style,
        children: <InlineSpan>[
          if (matchIndex > 0) TextSpan(text: fullText.substring(0, matchIndex)),
          TextSpan(
            text: fullText.substring(matchIndex, matchEnd),
            style: style?.copyWith(fontWeight: FontWeight.bold) ??
                const TextStyle(fontWeight: FontWeight.bold),
          ),
          if (matchEnd < fullText.length)
            TextSpan(text: fullText.substring(matchEnd)),
        ],
      ),
    );
  }
}
