import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:product_au/screens/home/favorite_screen.dart';
import 'package:product_au/screens/home/product_details_screen.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // SEARCH
  // ------------------------------------------------------------

  Future<void> _searchProducts() async {
    final query = _searchController.text.trim();

    await context.read<ProductProvider>().searchProducts(query);
  }

  void _clearSearch() {
    _searchController.clear();

    context.read<ProductProvider>().loadProducts();

    setState(() {});
  }

  // ------------------------------------------------------------
  // LOGOUT
  // ------------------------------------------------------------

  Future<void> _logout() async {
    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.logout();

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged out successfully'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.errorMessage ??
                'Unable to logout. Please try again.',
          ),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),

      // --------------------------------------------------------
      // APP BAR
      // --------------------------------------------------------

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,

        titleSpacing: 24,

        title: Text(
          'Products',
          style: GoogleFonts.manrope(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF222222),
          ),
        ),

      actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const FavoritesScreen(),
                ),
              );
            },
            tooltip: 'Favorites',
            icon: const Icon(
              Icons.favorite_border_rounded,
              color: Color(0xFFE45A72),
            ),
          ),

          // IconButton(
          //   onPressed: () {
          //     context
          //         .read<ProductProvider>()
          //         .refresh();
          //   },
          //   tooltip: 'Refresh',
          //   icon: const Icon(
          //     Icons.refresh_rounded,
          //     color: Color(0xFF222222),
          //   ),
          // ),

          const SizedBox(width: 4),

          IconButton(
            onPressed: _logout,
            tooltip: 'Logout',
            icon: const Icon(
              Icons.logout_rounded,
              color: Color(0xFF222222),
            ),
          ),

          const SizedBox(width: 16),
        ],
      ),

      // --------------------------------------------------------
      // BODY
      // --------------------------------------------------------

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double screenWidth = constraints.maxWidth;

            final double horizontalPadding =
                screenWidth >= 1200
                    ? 32
                    : screenWidth >= 900
                        ? 24
                        : screenWidth >= 600
                            ? 20
                            : 16;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1200,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),

                      const SizedBox(height: 20),

                      _buildSearchBar(),

                      const SizedBox(height: 24),

                      Expanded(
                        child: _buildProductContent(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // HEADER
  // ------------------------------------------------------------

  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile =
            constraints.maxWidth < 600;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Discover Products',
              style: GoogleFonts.manrope(
                fontSize: isMobile ? 22 : 26,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF222222),
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Find the products you are looking for',
              style: GoogleFonts.manrope(
                fontSize: isMobile ? 12 : 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF777777),
              ),
            ),
          ],
        );
      },
    );
  }

  // ------------------------------------------------------------
  // SEARCH BAR
  // ------------------------------------------------------------

  Widget _buildSearchBar() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE0D9F2),
        ),
      ),
      child: TextField(
        controller: _searchController,

        textInputAction: TextInputAction.search,

        onSubmitted: (_) {
          _searchProducts();
        },

        style: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF222222),
        ),

        decoration: InputDecoration(
          hintText: 'Search products...',

          hintStyle: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF999999),
          ),

          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xFF777777),
          ),

          suffixIcon:
              _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: _clearSearch,
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Color(0xFF777777),
                      ),
                    )
                  : IconButton(
                      onPressed: _searchProducts,
                      icon: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Color(0xFF6C4AB6),
                      ),
                    ),

          border: InputBorder.none,

          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
        ),

        onChanged: (_) {
          setState(() {});
        },
      ),
    );
  }

  // ------------------------------------------------------------
  // PRODUCT CONTENT
  // ------------------------------------------------------------

  Widget _buildProductContent() {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        // LOADING
        if (provider.isLoading) {
          return _buildLoadingState();
        }

        // ERROR
        if (provider.hasError) {
          return _buildErrorState(
            provider.errorMessage ??
                'Unable to load products.',
          );
        }

        // EMPTY
        if (provider.isEmpty) {
          return _buildEmptyState(
            provider.searchQuery.isNotEmpty
                ? 'No products found'
                : 'No products available',
            provider.searchQuery.isNotEmpty
                ? 'Try searching with a different keyword.'
                : 'There are no products to display right now.',
          );
        }

        // PRODUCTS
        return LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;

            final int columns =
                _getCrossAxisCount(width);

            const double spacing = 18;

            final double totalSpacing =
                spacing * (columns - 1);

            final double cardWidth =
                (width - totalSpacing) / columns;

            final double cardHeight =
                _getCardHeight(
              width,
              cardWidth,
            );

            return RefreshIndicator(
                onRefresh: () async {
    await provider.refresh();
  },
  color: const Color(0xFF6C4AB6),
  backgroundColor: Colors.white,
  displacement: 50,
  edgeOffset: 0,
              child: CustomScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(),

                slivers: [
                  // RESULT HEADER
                  SliverToBoxAdapter(
                    child: _buildResultHeader(
                      provider,
                    ),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 16),
                  ),

                  // PRODUCT GRID
                  SliverGrid(
                    delegate:
                        SliverChildBuilderDelegate(
                      (context, index) {
                        final product =
                            provider.products[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailsScreen(
                                productId: product.id,
                              ),
                            ),
                          );
                        },
                        child: _ProductCard(
                          product: product,
                          isFavorite: provider.isFavorite(
                            product.id,
                          ),
                        onFavorite: () {
                        final bool wasFavorite =
                            provider.isFavorite(product.id);

                        provider.toggleFavorite(product.id);

                        ScaffoldMessenger.of(context).hideCurrentSnackBar();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              wasFavorite
                                  ? 'Removed from favorites'
                                  : 'Added to favorites',
                            ),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                        ),
                      );
                      },
                      childCount:
                          provider.products.length,
                    ),

                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,

                      crossAxisSpacing: spacing,

                      mainAxisSpacing: spacing,

                      mainAxisExtent: cardHeight,
                    ),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 24),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ------------------------------------------------------------
  // RESPONSIVE COLUMN COUNT
  // ------------------------------------------------------------

  int _getCrossAxisCount(double width) {
    if (width >= 1200) {
      return 4;
    }

    if (width >= 900) {
      return 3;
    }

    if (width >= 600) {
      return 2;
    }

    return 2;
  }

  // ------------------------------------------------------------
  // RESPONSIVE CARD HEIGHT
  // ------------------------------------------------------------

  double _getCardHeight(
    double screenWidth,
    double cardWidth,
  ) {
    if (screenWidth < 600) {
      return 330;
    }

    if (screenWidth < 900) {
      return 350;
    }

    if (screenWidth < 1200) {
      return 365;
    }

    return 390;
  }

  // ------------------------------------------------------------
  // RESULT HEADER
  // ------------------------------------------------------------

  Widget _buildResultHeader(
    ProductProvider provider,
  ) {
    return Row(
      children: [
        Text(
          provider.searchQuery.isEmpty
              ? 'All Products'
              : 'Search Results',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF222222),
          ),
        ),

        const SizedBox(width: 8),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFEDE7FA),
            borderRadius:
                BorderRadius.circular(20),
          ),
          child: Text(
            '${provider.products.length}',
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF6C4AB6),
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // LOADING
  // ------------------------------------------------------------

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF6C4AB6),
      ),
    );
  }

  // ------------------------------------------------------------
  // ERROR
  // ------------------------------------------------------------

  Widget _buildErrorState(String message) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: 400,
          constraints: const BoxConstraints(
            maxWidth: 400,
          ),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFE0D9F2),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDECEC),
                  borderRadius:
                      BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.wifi_off_rounded,
                  size: 28,
                  color: Color(0xFFD9534F),
                ),
              ),

              const SizedBox(height: 18),

              Text(
                'Something went wrong',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF222222),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF777777),
                ),
              ),

              const SizedBox(height: 22),

              ElevatedButton.icon(
                onPressed: () {
                  context
                      .read<ProductProvider>()
                      .refresh();
                },

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF6C4AB6),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 13,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),

                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 18,
                ),

                label: Text(
                  'Retry',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // EMPTY
  // ------------------------------------------------------------

  Widget _buildEmptyState(
    String title,
    String description,
  ) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: 400,
          constraints: const BoxConstraints(
            maxWidth: 400,
          ),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFE0D9F2),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE7FA),
                  borderRadius:
                      BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  size: 30,
                  color: Color(0xFF6C4AB6),
                ),
              ),

              const SizedBox(height: 18),

              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF222222),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                description,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF777777),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =================================================================
// PRODUCT CARD
// =================================================================

class _ProductCard extends StatelessWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback onFavorite;

  const _ProductCard({
    required this.product,
    required this.isFavorite,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5E0EF),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      clipBehavior: Clip.antiAlias,

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // ------------------------------------------------------
          // IMAGE
          // ------------------------------------------------------

          Expanded(
            flex: 6,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  color: const Color(0xFFF7F5FA),
                  child: Image.network(
                    product.thumbnail,

                    fit: BoxFit.cover,

                    errorBuilder:
                        (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons
                              .image_not_supported_outlined,
                          size: 42,
                          color:
                              Color(0xFFB5B0BD),
                        ),
                      );
                    },

                    loadingBuilder:
                        (
                      context,
                      child,
                      loadingProgress,
                    ) {
                      if (loadingProgress ==
                          null) {
                        return child;
                      }

                      return const Center(
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color:
                              Color(0xFF6C4AB6),
                        ),
                      );
                    },
                  ),
                ),

                // FAVORITE
                Positioned(
                  top: 10,
                  right: 10,
                  child: Material(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(12),
                    elevation: 2,
                    child: InkWell(
                      onTap: onFavorite,
                      borderRadius:
                          BorderRadius.circular(12),
                      child: SizedBox(
                        width: 38,
                        height: 38,
                        child: Icon(
                          isFavorite
                              ? Icons
                                  .favorite_rounded
                              : Icons
                                  .favorite_border_rounded,
                          size: 20,
                          color: isFavorite
                              ? const Color(
                                  0xFFE45A72,
                                )
                              : const Color(
                                  0xFF555555,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ------------------------------------------------------
          // DETAILS
          // ------------------------------------------------------

          Expanded(
            flex: 4,
            child: Padding(
              padding:
                  const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // CATEGORY
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFFEDE7FA),
                      borderRadius:
                          BorderRadius.circular(7),
                    ),
                    child: Text(
                      product.category,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          GoogleFonts.manrope(
                        fontSize: 9,
                        fontWeight:
                            FontWeight.w700,
                        color:
                            const Color(0xFF6C4AB6),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // TITLE
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w800,
                      color:
                          const Color(0xFF222222),
                    ),
                  ),

                  const Spacer(),

                  // PRICE + RATING
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style:
                              GoogleFonts.manrope(
                            fontSize: 17,
                            fontWeight:
                                FontWeight.w800,
                            color: const Color(
                              0xFF6C4AB6,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      const Icon(
                        Icons.star_rounded,
                        size: 17,
                        color:
                            Color(0xFFF4B740),
                      ),

                      const SizedBox(width: 3),

                      Text(
                        product.rating
                            .toStringAsFixed(1),
                        style:
                            GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight:
                              FontWeight.w700,
                          color: const Color(
                            0xFF555555,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
