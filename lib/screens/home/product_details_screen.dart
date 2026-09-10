import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/product_provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState
    extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      context
          .read<ProductProvider>()
          .getProductDetails(
            widget.productId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF8F7FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,

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
          'Product Details',
          style: GoogleFonts.manrope(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF222222),
          ),
        ),
      ),

      body: Consumer<ProductProvider>(
        builder: (
          context,
          provider,
          child,
        ) {
          // ----------------------------------------------------
          // LOADING
          // ----------------------------------------------------

          if (provider.isLoadingDetails) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6C4AB6),
              ),
            );
          }

          // ----------------------------------------------------
          // ERROR
          // ----------------------------------------------------

          if (provider.hasDetailsError) {
            return _buildErrorState(
              provider.detailsErrorMessage ??
                  'Unable to load product.',
            );
          }

          // ----------------------------------------------------
          // EMPTY
          // ----------------------------------------------------

          if (provider.selectedProduct ==
              null) {
            return _buildErrorState(
              'Product details are not available.',
            );
          }

          // ----------------------------------------------------
          // PRODUCT
          // ----------------------------------------------------

          return _buildProductDetails(
            provider.selectedProduct!,
            provider,
          );
        },
      ),
    );
  }

  // ==========================================================
  // PRODUCT DETAILS
  // ==========================================================

  Widget _buildProductDetails(
    Product product,
    ProductProvider provider,
  ) {
    return LayoutBuilder(
      builder: (
        context,
        constraints,
      ) {
        final bool isDesktop =
            constraints.maxWidth >= 900;

        final double horizontalPadding =
            constraints.maxWidth >= 1200
                ? 32
                : constraints.maxWidth >= 900
                    ? 24
                    : 16;

        return SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(),

          child: Center(
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

                child: isDesktop
                    ? _buildDesktopLayout(
                        product,
                        provider,
                      )
                    : _buildMobileLayout(
                        product,
                        provider,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ==========================================================
  // DESKTOP
  // ==========================================================

  Widget _buildDesktopLayout(
    Product product,
    ProductProvider provider,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Expanded(
          flex: 5,
          child: _buildImageSection(
            product,
          ),
        ),

        const SizedBox(width: 28),

        Expanded(
          flex: 5,
          child: _buildInformationSection(
            product,
            provider,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // MOBILE / TABLET
  // ==========================================================

  Widget _buildMobileLayout(
    Product product,
    ProductProvider provider,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        _buildImageSection(product),

        const SizedBox(height: 24),

        _buildInformationSection(
          product,
          provider,
        ),
      ],
    );
  }

  // ==========================================================
  // IMAGE SECTION
  // ==========================================================

  Widget _buildImageSection(
    Product product,
  ) {
    final List<String> images =
        product.images.isNotEmpty
            ? product.images
            : [product.thumbnail];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE5E0EF),
        ),
      ),

      padding: const EdgeInsets.all(16),

      child: Column(
        children: [
          SizedBox(
            height: 400,
            width: double.infinity,

            child: PageView.builder(
              itemCount: images.length,

              itemBuilder:
                  (context, index) {
                return ClipRRect(
                  borderRadius:
                      BorderRadius.circular(16),

                  child: Container(
                    color:
                        const Color(0xFFF7F5FA),

                    child: Image.network(
                      images[index],

                      fit: BoxFit.contain,

                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return const Center(
                          child: Icon(
                            Icons
                                .image_not_supported_outlined,
                            size: 50,
                            color:
                                Color(0xFFB5B0BD),
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
                            color:
                                Color(0xFF6C4AB6),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),

      
        ],
      ),
    );
  }

  // ==========================================================
  // INFORMATION SECTION
  // ==========================================================

  Widget _buildInformationSection(
    Product product,
    ProductProvider provider,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE5E0EF),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // CATEGORY
          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),

            decoration: BoxDecoration(
              color:
                  const Color(0xFFEDE7FA),
              borderRadius:
                  BorderRadius.circular(8),
            ),

            child: Text(
              product.category,
              style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight:
                    FontWeight.w700,
                color:
                    const Color(0xFF6C4AB6),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // TITLE
          Text(
            product.title,
            style: GoogleFonts.manrope(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color:
                  const Color(0xFF222222),
            ),
          ),

          const SizedBox(height: 12),

          // RATING
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color:
                      const Color(0xFFFFF5DC),
                  borderRadius:
                      BorderRadius.circular(8),
                ),

                child: Row(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 18,
                      color:
                          Color(0xFFF4B740),
                    ),

                    const SizedBox(width: 4),

                    Text(
                      product.rating
                          .toStringAsFixed(1),
                      style:
                          GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w800,
                        color: const Color(
                          0xFF555555,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Text(
                'Rating',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight:
                      FontWeight.w500,
                  color:
                      const Color(0xFF888888),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // PRICE
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.center,
            children: [
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: GoogleFonts.manrope(
                  fontSize: 28,
                  fontWeight:
                      FontWeight.w800,
                  color:
                      const Color(0xFF6C4AB6),
                ),
              ),

              const SizedBox(width: 12),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                      const Color(0xFFEAF7EE),
                  borderRadius:
                      BorderRadius.circular(8),
                ),
                child: Text(
                  '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                  style:
                      GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w800,
                    color: const Color(
                      0xFF26834A,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          const Divider(
            color: Color(0xFFEAE6F0),
          ),

          const SizedBox(height: 20),

          // DESCRIPTION
          Text(
            'Description',
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight:
                  FontWeight.w800,
              color:
                  const Color(0xFF222222),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            product.description,
            style: GoogleFonts.manrope(
              fontSize: 13,
              height: 1.6,
              fontWeight:
                  FontWeight.w500,
              color:
                  const Color(0xFF666666),
            ),
          ),

          const SizedBox(height: 24),

          const Divider(
            color: Color(0xFFEAE6F0),
          ),

          const SizedBox(height: 20),

          // PRODUCT INFORMATION
          Text(
            'Product Information',
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight:
                  FontWeight.w800,
              color:
                  const Color(0xFF222222),
            ),
          ),

          const SizedBox(height: 14),

          _buildInfoRow(
            'Brand',
            product.brand,
          ),

          _buildInfoRow(
            'Category',
            product.category,
          ),

          _buildInfoRow(
            'Stock',
            '${product.stock} units',
          ),

          const SizedBox(height: 20),

          // TAGS
          if (product.tags.isNotEmpty) ...[
            Text(
              'Tags',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight:
                    FontWeight.w800,
                color:
                    const Color(0xFF222222),
              ),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  product.tags.map(
                (tag) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),

                    decoration:
                        BoxDecoration(
                      color: const Color(
                        0xFFF5F2FA,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),

                    child: Text(
                      '#$tag',
                      style:
                          GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight:
                            FontWeight.w700,
                        color:
                            const Color(
                          0xFF6C4AB6,
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ],

          const SizedBox(height: 24),

          // FAVORITE BUTTON
          SizedBox(
            width: double.infinity,
            height: 50,

            child: ElevatedButton.icon(
              onPressed: () {
                provider.toggleFavorite(
                  product.id,
                );
              },

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    provider.isFavorite(
                  product.id,
                )
                        ? const Color(
                            0xFFE45A72,
                          )
                        : const Color(
                            0xFF6C4AB6,
                          ),

                foregroundColor:
                    Colors.white,

                elevation: 0,

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
              ),

              icon: Icon(
                provider.isFavorite(
                  product.id,
                )
                    ? Icons.favorite_rounded
                    : Icons
                        .favorite_border_rounded,
              ),

              label: Text(
                provider.isFavorite(
                  product.id,
                )
                    ? 'Remove from Favorites'
                    : 'Add to Favorites',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // INFO ROW
  // ==========================================================

  Widget _buildInfoRow(
    String label,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 12),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight:
                    FontWeight.w600,
                color:
                    const Color(0xFF999999),
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight:
                    FontWeight.w700,
                color:
                    const Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // ERROR
  // ==========================================================

  Widget _buildErrorState(
    String message,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Container(
          width: 400,

          padding:
              const EdgeInsets.all(28),

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
              Container(
                width: 60,
                height: 60,

                decoration:
                    BoxDecoration(
                  color:
                      const Color(0xFFFDECEC),
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),

                child: const Icon(
                  Icons
                      .error_outline_rounded,
                  size: 30,
                  color:
                      Color(0xFFD9534F),
                ),
              ),

              const SizedBox(height: 18),

              Text(
                'Unable to load product',
                textAlign:
                    TextAlign.center,
                style:
                    GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.w800,
                  color: const Color(
                    0xFF222222,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                message,
                textAlign:
                    TextAlign.center,
                style:
                    GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight:
                      FontWeight.w500,
                  color: const Color(
                    0xFF777777,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              ElevatedButton.icon(
                onPressed: () {
                  context
                      .read<ProductProvider>()
                      .getProductDetails(
                        widget.productId,
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
                      const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 13,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),
                ),

                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 18,
                ),

                label: Text(
                  'Retry',
                  style:
                      GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w700,
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
