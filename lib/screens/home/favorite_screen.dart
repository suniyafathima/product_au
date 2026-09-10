import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/product_provider.dart';
import 'product_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF222222),
          ),
        ),

        title: Text(
          'Favorites',
          style: GoogleFonts.manrope(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF222222),
          ),
        ),
      ),

      body: SafeArea(
        child: Consumer<ProductProvider>(
          builder: (
            context,
            provider,
            child,
          ) {
            final favorites =
                provider.favoriteProducts;

            // --------------------------------------------------
            // EMPTY FAVORITES
            // --------------------------------------------------

            if (favorites.isEmpty) {
              return _buildEmptyState(
                context,
              );
            }

            // --------------------------------------------------
            // FAVORITES
            // --------------------------------------------------

            return LayoutBuilder(
              builder: (
                context,
                constraints,
              ) {
                final double width =
                    constraints.maxWidth;

                final double horizontalPadding =
                    width >= 1200
                        ? 32
                        : width >= 900
                            ? 24
                            : width >= 600
                                ? 20
                                : 16;

                return Center(
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(
                      maxWidth: 1200,
                    ),

                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(
                        horizontal:
                            horizontalPadding,
                        vertical: 24,
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          // HEADER
                          _buildHeader(
                            favorites.length,
                            width,
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // GRID
                          Expanded(
                            child:
                                _buildFavoriteGrid(
                              context,
                              favorites,
                              width,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  Widget _buildHeader(
    int count,
    double width,
  ) {
    final bool isMobile =
        width < 600;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Your Favorites',
                style: GoogleFonts.manrope(
                  fontSize:
                      isMobile ? 22 : 26,
                  fontWeight:
                      FontWeight.w800,
                  color:
                      const Color(0xFF222222),
                ),
              ),

              const SizedBox(height: 6),

              Text(
                isMobile
                    ? '$count saved product${count == 1 ? '' : 's'}'
                    : 'Products you have saved for later',
                style: GoogleFonts.manrope(
                  fontSize:
                      isMobile ? 12 : 14,
                  fontWeight:
                      FontWeight.w500,
                  color:
                      const Color(0xFF777777),
                ),
              ),
            ],
          ),
        ),

        // COUNT
        Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color:
                const Color(0xFFEDE7FA),
            borderRadius:
                BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              const Icon(
                Icons.favorite_rounded,
                size: 17,
                color:
                    Color(0xFFE45A72),
              ),

              const SizedBox(width: 6),

              Text(
                '$count',
                style:
                    GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight:
                      FontWeight.w800,
                  color:
                      const Color(0xFF6C4AB6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // GRID
  // ==========================================================

  Widget _buildFavoriteGrid(
    BuildContext context,
    List<Product> favorites,
    double width,
  ) {
    final int columns =
        _getCrossAxisCount(width);

    const double spacing = 18;

    final double cardHeight =
        _getCardHeight(width);

    return GridView.builder(
      physics:
          const AlwaysScrollableScrollPhysics(),

      padding:
          const EdgeInsets.only(
        bottom: 24,
      ),

      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        mainAxisExtent: cardHeight,
      ),

      itemCount: favorites.length,

      itemBuilder: (
        context,
        index,
      ) {
        final product =
            favorites[index];

        return _FavoriteProductCard(
          product: product,

          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ProductDetailsScreen(
                  productId: product.id,
                ),
              ),
            );
          },

        onRemove: () {
  context
      .read<ProductProvider>()
      .toggleFavorite(product.id);

  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Removed from favorites',
        style: GoogleFonts.manrope(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
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
        );
      },
    );
  }

  // ==========================================================
  // RESPONSIVE COLUMNS
  // ==========================================================

  int _getCrossAxisCount(
    double width,
  ) {
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

  // ==========================================================
  // RESPONSIVE CARD HEIGHT
  // ==========================================================

  double _getCardHeight(
    double width,
  ) {
    if (width < 600) {
      return 330;
    }

    if (width < 900) {
      return 350;
    }

    if (width < 1200) {
      return 365;
    }

    return 390;
  }

  // ==========================================================
  // EMPTY STATE
  // ==========================================================

  Widget _buildEmptyState(
    BuildContext context,
  ) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(24),

        child: Container(
          width: 420,

          constraints:
              const BoxConstraints(
            maxWidth: 420,
          ),

          padding:
              const EdgeInsets.all(32),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(20),
            border: Border.all(
              color:
                  const Color(0xFFE0D9F2),
            ),
          ),

          child: Column(
            mainAxisSize:
                MainAxisSize.min,

            children: [
              // ICON
              Container(
                width: 72,
                height: 72,

                decoration:
                    BoxDecoration(
                  color:
                      const Color(0xFFFCECEF),
                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),

                child: const Icon(
                  Icons
                      .favorite_border_rounded,
                  size: 36,
                  color:
                      Color(0xFFE45A72),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'No Favorites Yet',
                textAlign:
                    TextAlign.center,
                style:
                    GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.w800,
                  color: const Color(
                    0xFF222222,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Products you add to your favorites will appear here.',
                textAlign:
                    TextAlign.center,
                style:
                    GoogleFonts.manrope(
                  fontSize: 13,
                  height: 1.5,
                  fontWeight:
                      FontWeight.w500,
                  color: const Color(
                    0xFF777777,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 48,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(
                      0xFF6C4AB6,
                    ),
                    foregroundColor:
                        Colors.white,
                    elevation: 0,

                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 24,
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        12,
                      ),
                    ),
                  ),

                  child: Text(
                    'Explore Products',
                    style:
                        GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
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
// FAVORITE PRODUCT CARD
// =================================================================

class _FavoriteProductCard
    extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _FavoriteProductCard({
    required this.product,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius:
            BorderRadius.circular(18),

        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.circular(18),

            border: Border.all(
              color:
                  const Color(0xFFE5E0EF),
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withOpacity(0.04),
                blurRadius: 12,
                offset:
                    const Offset(0, 4),
              ),
            ],
          ),

          clipBehavior:
              Clip.antiAlias,

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              // ------------------------------------------------
              // IMAGE
              // ------------------------------------------------

              Expanded(
                flex: 6,

                child: Stack(
                  children: [
                    Container(
                      width:
                          double.infinity,

                      color: const Color(
                        0xFFF7F5FA,
                      ),

                      child: Image.network(
                        product.thumbnail,

                        fit: BoxFit.cover,

                        errorBuilder: (
                          context,
                          error,
                          stackTrace,
                        ) {
                          return const Center(
                            child: Icon(
                              Icons
                                  .image_not_supported_outlined,
                              size: 42,
                              color: Color(
                                0xFFB5B0BD,
                              ),
                            ),
                          );
                        },

                        loadingBuilder: (
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
                              color: Color(
                                0xFF6C4AB6,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // REMOVE FAVORITE
                    Positioned(
                      top: 10,
                      right: 10,

                      child: Material(
                        color: Colors.white,

                        borderRadius:
                            BorderRadius
                                .circular(
                          12,
                        ),

                        elevation: 2,

                        child: InkWell(
                          onTap: onRemove,

                          borderRadius:
                              BorderRadius
                                  .circular(
                            12,
                          ),

                          child: const SizedBox(
                            width: 38,
                            height: 38,

                            child: Icon(
                              Icons
                                  .favorite_rounded,
                              size: 20,
                              color: Color(
                                0xFFE45A72,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ------------------------------------------------
              // DETAILS
              // ------------------------------------------------

              Expanded(
                flex: 4,

                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    14,
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [
                      // CATEGORY
                      Container(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),

                        decoration:
                            BoxDecoration(
                          color: const Color(
                            0xFFEDE7FA,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            7,
                          ),
                        ),

                        child: Text(
                          product.category,

                          maxLines: 1,

                          overflow:
                              TextOverflow
                                  .ellipsis,

                          style:
                              GoogleFonts
                                  .manrope(
                            fontSize: 9,
                            fontWeight:
                                FontWeight
                                    .w700,
                            color: const Color(
                              0xFF6C4AB6,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // TITLE
                      Text(
                        product.title,

                        maxLines: 2,

                        overflow:
                            TextOverflow
                                .ellipsis,

                        style:
                            GoogleFonts
                                .manrope(
                          fontSize: 14,
                          fontWeight:
                              FontWeight
                                  .w800,
                          color: const Color(
                            0xFF222222,
                          ),
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
                                  TextOverflow
                                      .ellipsis,

                              style:
                                  GoogleFonts
                                      .manrope(
                                fontSize: 17,
                                fontWeight:
                                    FontWeight
                                        .w800,
                                color:
                                    const Color(
                                  0xFF6C4AB6,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 8,
                          ),

                          const Icon(
                            Icons
                                .star_rounded,
                            size: 17,
                            color: Color(
                              0xFFF4B740,
                            ),
                          ),

                          const SizedBox(
                            width: 3,
                          ),

                          Text(
                            product.rating
                                .toStringAsFixed(
                              1,
                            ),

                            style:
                                GoogleFonts
                                    .manrope(
                              fontSize: 11,
                              fontWeight:
                                  FontWeight
                                      .w700,
                              color:
                                  const Color(
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
        ),
      ),
    );
  }
}
