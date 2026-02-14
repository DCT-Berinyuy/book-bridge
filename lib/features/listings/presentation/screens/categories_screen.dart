import 'package:book_bridge/features/listings/presentation/viewmodels/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Textbooks', 'icon': Icons.school_rounded, 'color': Colors.blue},
      {
        'name': 'Fiction',
        'icon': Icons.auto_stories_rounded,
        'color': Colors.purple,
      },
      {'name': 'Science', 'icon': Icons.science_rounded, 'color': Colors.teal},
      {
        'name': 'History',
        'icon': Icons.history_edu_rounded,
        'color': Colors.brown,
      },
      {'name': 'GCE', 'icon': Icons.assignment_rounded, 'color': Colors.orange},
      {
        'name': 'Business',
        'icon': Icons.business_center_rounded,
        'color': Colors.indigo,
      },
      {
        'name': 'Technology',
        'icon': Icons.computer_rounded,
        'color': Colors.cyan,
      },
      {'name': 'Arts', 'icon': Icons.palette_rounded, 'color': Colors.pink},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
            child: Text(
              'What is your interest?',
              style: GoogleFonts.montserrat(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final name = category['name'] as String;
                final icon = category['icon'] as IconData;
                final color = category['color'] as Color;

                return GestureDetector(
                  onTap: () {
                    // Set the category in HomeViewModel and navigate to Home
                    context.read<HomeViewModel>().setSelectedCategory(name);
                    context.go('/home');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: color.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, size: 32, color: color),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
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
}
