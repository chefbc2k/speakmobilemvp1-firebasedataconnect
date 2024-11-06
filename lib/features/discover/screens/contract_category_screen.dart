import 'package:flutter/material.dart';
import 'package:speakmobilemvp/core/services/frontend/contract_service.dart';
import 'package:speakmobilemvp/features/discover/widgets/category_metrics_card.dart';
import 'package:speakmobilemvp/core/utils/error_handler.dart';
import 'package:speakmobilemvp/core/services/analytics/analytics_service.dart';

class ContractCategoryScreen extends StatefulWidget {
  final ContractService contractService;
  final AnalyticsService analytics;
  final String categoryId;
  final String categoryTitle;

  const ContractCategoryScreen({
    super.key,
    required this.contractService,
    required this.analytics,
    required this.categoryId,
    required this.categoryTitle,
  });

  @override
  State<ContractCategoryScreen> createState() => _ContractCategoryScreenState();
}

class _ContractCategoryScreenState extends State<ContractCategoryScreen> {
  ContractCategory? _category;
  CategoryStatistics? _statistics;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategoryData();
    _logScreenView();
  }

  Future<void> _logScreenView() async {
    await widget.analytics.logScreenView(
      screenName: 'contract_category',
      screenClass: 'ContractCategoryScreen',
      parameters: {
        'category_id': widget.categoryId,
        'category_title': widget.categoryTitle,
      },
    );
  }

  Future<void> _loadCategoryData() async {
    setState(() => _isLoading = true);

    try {
      final categories = await widget.contractService.getContractCategories(
        parentCategory: widget.categoryId,
      );

      final statistics = await widget.contractService.getCategoryStatistics(
        category: widget.categoryId,
      );

      setState(() {
        _category = categories.firstWhere((c) => c.id == widget.categoryId);
        _statistics = statistics;
        _isLoading = false;
      });

      await widget.analytics.logEvent(
        name: 'view_category_details',
        parameters: {
          'category_id': widget.categoryId,
          'contract_count': _category?.contractCount,
          'has_subcategories': _category?.subcategories?.isNotEmpty,
        },
      );
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ErrorHandler.showError(
          context: context,
          error: 'Failed to load category data: $e',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Show category information dialog
              widget.analytics.logEvent(
                name: 'view_category_info',
                parameters: {'category_id': widget.categoryId},
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadCategoryData,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_statistics != null)
                      CategoryMetricsCard(statistics: _statistics!),
                    if (_category?.description != null)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _category!.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    if (_category?.subcategories?.isNotEmpty == true) ...[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Subcategories',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: _category!.subcategories!.length,
                        itemBuilder: (context, index) {
                          final subcategoryId = _category!.subcategories![index];
                          return _SubcategoryCard(
                            categoryId: subcategoryId,
                            onTap: () {
                              widget.analytics.logEvent(
                                name: 'select_subcategory',
                                parameters: {'subcategory_id': subcategoryId},
                              );
                              // Navigate to subcategory
                            },
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}

class _SubcategoryCard extends StatelessWidget {
  final String categoryId;
  final VoidCallback onTap;

  const _SubcategoryCard({
    required this.categoryId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                categoryId,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const Icon(Icons.arrow_forward),
            ],
          ),
        ),
      ),
    );
  }
} 