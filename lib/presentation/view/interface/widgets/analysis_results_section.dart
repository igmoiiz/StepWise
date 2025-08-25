// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../../core/models/analysis_models.dart';

class AnalysisResultsSection extends StatefulWidget {
  final AnalysisResult analysis;

  const AnalysisResultsSection({super.key, required this.analysis});

  @override
  State<AnalysisResultsSection> createState() => _AnalysisResultsSectionState();
}

class _AnalysisResultsSectionState extends State<AnalysisResultsSection>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideAnimations = List.generate(
      6,
      (index) =>
          Tween<Offset>(
            begin: Offset(0, 0.5 + (index * 0.1)),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: _slideController,
              curve: Interval(
                index * 0.1,
                0.6 + (index * 0.1),
                curve: Curves.easeOutCubic,
              ),
            ),
          ),
    );

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  Color _getSuccessColor(int probability) {
    if (probability >= 70) return Colors.green;
    if (probability >= 40) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final analysis = widget.analysis;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SlideTransition(
          position: _slideAnimations[0],
          child: Card(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.business,
                        color: theme.colorScheme.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Product Overview',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${analysis.domain} • ${analysis.productType}',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SlideTransition(
          position: _slideAnimations[1],
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _getSuccessColor(
                            analysis.marketAnalysis.successProbability,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.trending_up,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Success Probability',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        '${analysis.marketAnalysis.successProbability}%',
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getSuccessColor(
                            analysis.marketAnalysis.successProbability,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: LinearProgressIndicator(
                          value:
                              analysis.marketAnalysis.successProbability / 100,
                          backgroundColor: theme.colorScheme.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getSuccessColor(
                              analysis.marketAnalysis.successProbability,
                            ),
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SlideTransition(
          position: _slideAnimations[2],
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.analytics,
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Market Analysis',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildMarketMetric(
                    'Market Size',
                    analysis.marketAnalysis.estimatedMarketSize,
                  ),
                  _buildMarketMetric(
                    'Customer Value',
                    analysis.marketAnalysis.customerValue,
                  ),
                  _buildMarketMetric(
                    'Adoption Rate',
                    analysis.marketAnalysis.adoptionRate,
                  ),
                  _buildMarketMetric(
                    'Competition Level',
                    analysis.marketAnalysis.competitionLevel,
                  ),
                  const SizedBox(height: 16),
                  ExpansionTile(
                    title: const Text('Critical Commentary'),
                    leading: const Icon(Icons.warning_amber),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          analysis.marketAnalysis.detailedCommentary,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SlideTransition(
          position: _slideAnimations[3],
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Target Customers',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...analysis.marketAnalysis.targetCustomers.map(
                    (customer) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Card(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customer.segment,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                customer.description,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SlideTransition(
          position: _slideAnimations[4],
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Major Risks',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...analysis.marketAnalysis.risks.map(
                    (risk) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.fiber_manual_record,
                            color: Colors.red,
                            size: 8,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              risk,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SlideTransition(
          position: _slideAnimations[5],
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.code,
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Technical Details',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ExpansionTile(
                    title: const Text('Features & Complexity'),
                    children: analysis.features
                        .map(
                          (feature) => ListTile(
                            title: Text(feature.name),
                            subtitle: Text('Complexity: ${feature.complexity}'),
                            trailing: Chip(
                              label: Text('${feature.subtasks.length} tasks'),
                              backgroundColor:
                                  theme.colorScheme.primaryContainer,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  ExpansionTile(
                    title: const Text('Suggested Tech Stack'),
                    children: [
                      _buildStackItem(
                        'Frontend',
                        analysis.suggestedStack.frontend,
                      ),
                      _buildStackItem(
                        'Backend',
                        analysis.suggestedStack.backend,
                      ),
                      _buildStackItem('Database', analysis.suggestedStack.db),
                      _buildStackItem(
                        'Infrastructure',
                        analysis.suggestedStack.infra,
                      ),
                      _buildStackItem('AI/ML', analysis.suggestedStack.ai),
                    ],
                  ),
                  ExpansionTile(
                    title: const Text('Development Roadmap'),
                    children: analysis.roadmap
                        .asMap()
                        .entries
                        .map(
                          (entry) => ListTile(
                            leading: CircleAvatar(
                              backgroundColor: theme.colorScheme.primary,
                              child: Text(
                                '${entry.key + 1}',
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(entry.value),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMarketMetric(String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStackItem(String category, String technology) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(category),
      trailing: Chip(
        label: Text(technology),
        backgroundColor: theme.colorScheme.secondaryContainer,
      ),
    );
  }
}
