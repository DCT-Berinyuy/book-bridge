import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:book_bridge/features/listings/presentation/viewmodels/sell_viewmodel.dart';

/// Screen for creating and selling a new book listing.
///
/// This screen provides a form for users to input book details,
/// select a condition, upload an image, and create a new listing.
class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Shows a dialog for selecting image source (gallery or camera).
  void _showImageSelectionDialog(
    BuildContext context,
    SellViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop(); // Close dialog
                  await viewModel.pickImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop(); // Close dialog
                  await viewModel.pickImageFromCamera();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/home'),
        ),
        title: const Text('Sell a Book'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Help button functionality
            },
          ),
        ],
      ),
      body: Consumer<SellViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.sellState == SellState.success) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                context.go('/home');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Listing created successfully!'),
                    backgroundColor: const Color(0xFF1A4D8C), // Primary green
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            });
          } else if (viewModel.sellState == SellState.error &&
              viewModel.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(viewModel.errorMessage!),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    duration: const Duration(seconds: 3),
                  ),
                );
                // Reset state to avoid repeated snackbars
                // Note: Logic to reset state should ideally be in ViewModel or handled differently,
                // but for now this ensures the user sees the error.
              }
            });
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Image upload area
                  GestureDetector(
                    onTap: () {
                      _showImageSelectionDialog(context, viewModel);
                    },
                    child: Container(
                      width: double.infinity,
                      height:
                          MediaQuery.of(context).size.height *
                          0.25, // Responsive height
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.outlineVariant.withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: viewModel.isLoading && viewModel.imageUrl == null
                          ? const Center(child: CircularProgressIndicator())
                          : viewModel.imageUrl != null &&
                                viewModel.imageUrl!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                viewModel.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildImagePlaceholder();
                                },
                              ),
                            )
                          : _buildImagePlaceholder(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Book Title
                  const Text(
                    'Book Title',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'e.g. Pure Physics',
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    onChanged: viewModel.setTitle,
                  ),
                  const SizedBox(height: 24),

                  // Author
                  const Text(
                    'Author',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _authorController,
                    decoration: InputDecoration(
                      hintText: 'e.g. Nelkon & Parker',
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an author';
                      }
                      return null;
                    },
                    onChanged: viewModel.setAuthor,
                  ),
                  const SizedBox(height: 24),

                  // Price
                  const Text(
                    'Price (FCFA)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '0',
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface,
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a price';
                            }
                            final price = int.tryParse(value);
                            if (price == null || price <= 0) {
                              return 'Please enter a valid price';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            final price = int.tryParse(value);
                            if (price != null) {
                              viewModel.setPrice(price);
                            }
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                          ),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: const Icon(Icons.payments, size: 24),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Describe the book (edition, language, etc.)',
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    onChanged: viewModel.setDescription,
                  ),
                  const SizedBox(height: 24),

                  // Condition
                  const Text(
                    'Book Condition',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Social Venture Section
                  const Text(
                    'Social Venture Features',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Seller Type
                  const Text(
                    'Seller Type',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: viewModel.sellerType,
                        isExpanded: true,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        items: const [
                          DropdownMenuItem(
                            value: 'individual',
                            child: Text('Individual Student'),
                          ),
                          DropdownMenuItem(
                            value: 'bookshop',
                            child: Text('Verified Bookshop'),
                          ),
                          DropdownMenuItem(
                            value: 'author',
                            child: Text('Local Author'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            viewModel.setSellerType(value);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Buy-Back Eligibility
                  SwitchListTile(
                    title: const Text(
                      'Eligible for Buy-Back',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: const Text(
                      'Permit students to sell this book back when finished.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    value: viewModel.isBuyBackEligible,
                    onChanged: viewModel.setIsBuyBackEligible,
                    activeColor: const Color(0xFF1A4D8C),
                  ),
                  const SizedBox(height: 16),
                  // Stock Count (for non-individuals)
                  if (viewModel.sellerType != 'individual') ...[
                    const Text(
                      'Available Stock',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: viewModel.stockCount.toString(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'e.g. 10',
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      onChanged: (value) {
                        final stock = int.tryParse(value);
                        if (stock != null) {
                          viewModel.setStockCount(stock);
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                  const SizedBox(height: 16),

                  // Location info
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Listing will be visible in your current region',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Post Listing button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: viewModel.isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                viewModel.createListing();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF1A4D8C,
                        ), // Scholar Blue
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: viewModel.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Post Listing',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_a_photo,
          size: MediaQuery.of(context).size.width * 0.15, // Responsive size
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          'Add book photos',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path();

    // Top border
    _drawDashedLine(path, 0, 0, size.width, 0);
    // Right border
    _drawDashedLine(path, size.width, 0, size.width, size.height);
    // Bottom border
    _drawDashedLine(path, size.width, size.height, 0, size.height);
    // Left border
    _drawDashedLine(path, 0, size.height, 0, 0);

    canvas.drawPath(path, paint);
  }

  void _drawDashedLine(
    Path path,
    double startX,
    double startY,
    double endX,
    double endY,
  ) {
    final dx = endX - startX;
    final dy = endY - startY;
    final length = sqrt(dx * dx + dy * dy);

    var currentX = startX;
    var currentY = startY;

    var drawSegment = true;
    while (true) {
      final segmentLength = drawSegment ? strokeWidth * 3 : gap;
      if (segmentLength > length) {
        path.lineTo(endX, endY);
        break;
      }

      final fraction = segmentLength / length;
      final nextX = currentX + dx * fraction;
      final nextY = currentY + dy * fraction;

      if (drawSegment) {
        path.moveTo(currentX, currentY);
        path.lineTo(nextX, nextY);
      } else {
        path.moveTo(nextX, nextY);
      }

      currentX = nextX;
      currentY = nextY;

      final remainingLength = sqrt(
        (endX - currentX) * (endX - currentX) +
            (endY - currentY) * (endY - currentY),
      );
      if (remainingLength < gap) {
        break;
      }

      drawSegment = !drawSegment;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
