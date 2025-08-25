// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/provider/api_provider.dart';
import '../../../../core/provider/ui_state_provider.dart';
import 'analysis_results_section.dart';

class AnalysisInputSection extends StatefulWidget {
  const AnalysisInputSection({super.key});

  @override
  State<AnalysisInputSection> createState() => _AnalysisInputSectionState();
}

class _AnalysisInputSectionState extends State<AnalysisInputSection>
    with TickerProviderStateMixin {
  final TextEditingController _ideaController = TextEditingController();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ideaController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _analyzeIdea() async {
    if (_ideaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your startup idea'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    _pulseController.repeat(reverse: true);

    final apiProvider = context.read<ApplicationProgramInterfaceProvider>();
    final result = await apiProvider.breakdownGeneration(_ideaController.text.trim());

    _pulseController.stop();
    _pulseController.reset();
    
    debugPrint("UI: Analysis result received: ${result != null ? 'Success' : 'Failed'}");
    debugPrint("UI: Current analysis in provider: ${apiProvider.currentAnalysis != null ? 'Available' : 'Null'}");
    debugPrint("UI: Provider error: ${apiProvider.error}");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<ApplicationProgramInterfaceProvider>(
      builder: (context, apiProvider, child) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'StepWise AI',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                centerTitle: true,
              ),
              actions: [
                Consumer<UIStateProvider>(
                  builder: (context, uiState, child) {
                    return IconButton(
                      icon: Icon(
                        uiState.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      ),
                      onPressed: uiState.toggleTheme,
                    );
                  },
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Describe Your Startup Idea',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Be specific about your product, target market, and value proposition. The more detail you provide, the better the analysis.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _ideaController,
                            maxLines: 6,
                            decoration: InputDecoration(
                              hintText:
                                  'e.g., A mobile app that connects local farmers directly with consumers, eliminating middlemen and providing fresh produce at lower prices...',
                              hintStyle: TextStyle(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: theme.colorScheme.surfaceContainerHighest,
                            ),
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: apiProvider.isLoading
                                      ? _pulseAnimation.value
                                      : 1.0,
                                  child: FilledButton.icon(
                                    onPressed: apiProvider.isLoading
                                        ? null
                                        : _analyzeIdea,
                                    icon: apiProvider.isLoading
                                        ? SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    theme.colorScheme.onPrimary,
                                                  ),
                                            ),
                                          )
                                        : const Icon(Icons.analytics),
                                    label: Text(
                                      apiProvider.isLoading
                                          ? 'Analyzing...'
                                          : 'Analyze Idea',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: FilledButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          if (apiProvider.error != null) ...[
                            const SizedBox(height: 16),
                            Card(
                              color: theme.colorScheme.errorContainer,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: theme.colorScheme.error,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        apiProvider.error!,
                                        style: TextStyle(
                                          color: theme
                                              .colorScheme
                                              .onErrorContainer,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: apiProvider.clearError,
                                      color: theme.colorScheme.error,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (apiProvider.currentAnalysis != null) ...[
                    const SizedBox(height: 20),
                    AnalysisResultsSection(
                      analysis: apiProvider.currentAnalysis!,
                    ),
                  ],
                ]),
              ),
            ),
          ],
        );
      },
    );
  }
}
