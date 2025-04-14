// Page for confirming the recognized food
import 'dart:io';

import 'package:flutter/material.dart';

class FoodConfirmationPage extends StatefulWidget {
  final Map<String, dynamic> recognitionData;
  final File imageFile;

  const FoodConfirmationPage({
    Key? key,
    required this.recognitionData,
    required this.imageFile,
  }) : super(key: key);

  @override
  State<FoodConfirmationPage> createState() => _FoodConfirmationPageState();
}

class _FoodConfirmationPageState extends State<FoodConfirmationPage> {
  final Map<String, bool> _expandedCards = {};
  Map<String, dynamic>? _selectedFood;
  Map<String, dynamic>? _selectedSubclass;

  @override
  void initState() {
    super.initState();
    // Initialize first item as expanded
    if (widget.recognitionData['recognition_results'].isNotEmpty) {
      _expandedCards[widget.recognitionData['recognition_results'][0]['name']] =
          true;
    }
  }

  void _toggleExpanded(String key) {
    setState(() {
      _expandedCards[key] = !(_expandedCards[key] ?? false);
    });
  }

  void _selectFood(Map<String, dynamic> food) {
    setState(() {
      _selectedFood = food;
      _selectedSubclass = null;
    });
  }

  void _selectSubclass(Map<String, dynamic> subclass) {
    setState(() {
      _selectedSubclass = subclass;
    });
  }

  void _confirmFoodSelection() {
    // Here you would implement the logic to save the selected food
    // and fetch nutrition information

    final food = _selectedSubclass ?? _selectedFood;
    if (food == null) return;

    // For now, just show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected: ${food['name']}')),
    );

    // Return to the previous screen or navigate to a nutrition details screen
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final recognitionResults = List<Map<String, dynamic>>.from(
      widget.recognitionData['recognition_results'],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Food'),
      ),
      body: Column(
        children: [
          // Image preview
          SizedBox(
            height: 200,
            width: double.infinity,
            child: Image.file(
              widget.imageFile,
              fit: BoxFit.cover,
            ),
          ),

          // Food occasion
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Detected as: ${widget.recognitionData['occasion_info']['translation'] ?? 'Unknown'}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          // Food family
          if (widget.recognitionData['foodFamily'] != null &&
              widget.recognitionData['foodFamily'].isNotEmpty)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Text(
                'Food Family: ${widget.recognitionData['foodFamily'][0]['name']} '
                '(${(widget.recognitionData['foodFamily'][0]['prob'] * 100).toStringAsFixed(0)}%)',
                style: const TextStyle(fontSize: 14),
              ),
            ),

          // Recognition results list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: recognitionResults.length,
              itemBuilder: (context, index) {
                final food = recognitionResults[index];
                final bool isSelected = _selectedFood == food;
                final isExpanded = _expandedCards[food['name']] ?? false;
                final hasSubclasses =
                    food['subclasses'] != null && food['subclasses'].isNotEmpty;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: isSelected ? 4 : 1,
                  color: isSelected
                      ? Theme.of(context).colorScheme.secondaryContainer
                      : null,
                  child: Column(
                    children: [
                      // Main food item
                      ListTile(
                        title: Text(
                          food['name'].toString().toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer
                                : null,
                          ),
                        ),
                        subtitle: Text(
                          'Probability: ${(food['prob'] * 100).toStringAsFixed(1)}%',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildNutriScoreBadge(food),
                            if (hasSubclasses)
                              IconButton(
                                icon: Icon(
                                  isExpanded
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                ),
                                onPressed: () => _toggleExpanded(food['name']),
                              ),
                          ],
                        ),
                        onTap: () => _selectFood(food),
                        selected: isSelected,
                      ),

                      // Subclasses (if any and if expanded)
                      if (isExpanded && hasSubclasses)
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Column(
                            children: List.generate(
                              food['subclasses'].length,
                              (subIndex) {
                                final subclass = food['subclasses'][subIndex];
                                final bool isSubclassSelected =
                                    _selectedSubclass == subclass;

                                return ListTile(
                                  title: Text(
                                    subclass['name'],
                                    style: TextStyle(
                                      color: isSubclassSelected
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : null,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Probability: ${(subclass['prob'] * 100).toStringAsFixed(1)}%',
                                  ),
                                  trailing: _buildNutriScoreBadge(subclass),
                                  onTap: () => _selectSubclass(subclass),
                                  selected: isSubclassSelected,
                                  tileColor: isSubclassSelected
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primaryContainer
                                          .withOpacity(0.3)
                                      : null,
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Confirm button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: (_selectedFood != null) ? _confirmFoodSelection : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Confirm Selection'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutriScoreBadge(Map<String, dynamic> food) {
    if (food['nutri_score'] == null) {
      return const SizedBox.shrink();
    }

    final category = food['nutri_score']['nutri_score_category'] as String;
    final score = food['nutri_score']['nutri_score_standardized'] as int;

    Color badgeColor;
    switch (category) {
      case 'A':
        badgeColor = Colors.green;
        break;
      case 'B':
        badgeColor = Colors.lightGreen;
        break;
      case 'C':
        badgeColor = Colors.yellow;
        break;
      case 'D':
        badgeColor = Colors.orange;
        break;
      case 'E':
        badgeColor = Colors.red;
        break;
      default:
        badgeColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        '$category ($score)',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
