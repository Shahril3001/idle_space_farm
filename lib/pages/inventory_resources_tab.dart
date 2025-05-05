import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/resource_model.dart';
import '../providers/game_provider.dart';

class ResourcesTab extends StatefulWidget {
  @override
  _ResourcesTabState createState() => _ResourcesTabState();
}

class _ResourcesTabState extends State<ResourcesTab> {
  String _sortBy = 'Name';
  String _filterQuery = '';

  // List of all resource names to display (excluding 'Default')
  final List<String> _resourceNames = [
    'Gold',
    'Silver',
    'Metal',
    'Rune',
    'Skill Book',
    'Awakening Shard',
    'Enhancement Stone',
    'Forge Material',
    'Girl Scroll',
    'Equipment Chest',
    'Gem',
    'Diamond',
    'Stamina',
    'Dungeon Key',
    'Arena Ticket',
    'Raid Ticket',
  ];

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    // Get resources with their amounts
    List<Resource> resources = _resourceNames
        .map((name) => gameProvider.getResourceByName(name))
        .where((resource) => resource != null && resource.amount > 0)
        .cast<Resource>()
        .toList();

    resources = _applyFiltersAndSorting(resources);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          _buildFilterControls(),
          resources.isEmpty
              ? _buildEmptyState()
              : Expanded(child: _buildResourcesGrid(resources)),
        ],
      ),
    );
  }

  List<Resource> _applyFiltersAndSorting(List<Resource> resources) {
    // Apply search filter
    if (_filterQuery.isNotEmpty) {
      resources = resources
          .where((resource) =>
              resource.name.toLowerCase().contains(_filterQuery.toLowerCase()))
          .toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'Name':
        resources.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Amount':
        resources.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case 'Type':
        // Default to name sorting if no type sorting implemented
        resources.sort((a, b) => a.name.compareTo(b.name));
        break;
    }

    return resources;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No resources available',
        style: TextStyle(color: Colors.white70),
      ),
    );
  }

  Widget _buildResourcesGrid(List<Resource> resources) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.9,
      ),
      itemCount: resources.length,
      itemBuilder: (context, index) {
        final resource = resources[index];
        return GestureDetector(
          onTap: () => _showResourceDetails(context, resource),
          child: Card(
            color: Colors.black.withOpacity(0.8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Image.asset(
                            resource.imagePath,
                            width: 40,
                            height: 40,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.monetization_on, size: 40),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.amberAccent.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _formatAmount(resource.amount),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    resource.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.search, color: Colors.black),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                    style: const TextStyle(color: Colors.black),
                    onChanged: (value) => setState(() => _filterQuery = value),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFCAA04D),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: DropdownButton<String>(
                  value: _sortBy,
                  onChanged: (String? newValue) =>
                      setState(() => _sortBy = newValue!),
                  items: ['Name', 'Amount', 'Type'].map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value,
                          style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  dropdownColor: const Color(0xFFCAA04D),
                  icon: const Icon(Icons.sort, color: Colors.white),
                  underline: const SizedBox(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showResourceDetails(BuildContext context, Resource resource) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('View Details'),
                onTap: () {
                  Navigator.pop(context);
                  _showResourceDetailedView(context, resource);
                },
              ),
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Exchange Resources'),
                onTap: () {
                  Navigator.pop(context);
                  _showExchangeDialog(context, resource);
                },
              ),
              const ListTile(
                leading: Icon(Icons.close),
                title: Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showResourceDetailedView(BuildContext context, Resource resource) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(resource.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: resource.color.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: resource.color,
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    resource.imagePath,
                    width: 60,
                    height: 60,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.monetization_on, size: 60),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Amount: ${_formatAmount(resource.amount)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(_getResourceDescription(resource.name)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _showExchangeDialog(
      BuildContext context, Resource resource) async {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final exchangeOptions = _resourceNames
        .where((name) => name != resource.name)
        .map((name) => gameProvider.getResourceByName(name))
        .where((res) => res != null)
        .cast<Resource>()
        .toList();

    Resource? selectedResource;
    double fromAmount = 1;
    double toAmount = 1;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Exchange ${resource.name}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('You have: ${_formatAmount(resource.amount)}'),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Amount to exchange',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              fromAmount = double.tryParse(value) ?? 1;
                              if (selectedResource != null) {
                                toAmount = fromAmount; // 1:1 exchange rate
                                setState(() {});
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        _buildResourceIcon(resource, 60),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('for'),
                    const SizedBox(height: 16),
                    DropdownButton<Resource>(
                      value: selectedResource,
                      hint: const Text('Select resource'),
                      onChanged: (Resource? newValue) {
                        setState(() {
                          selectedResource = newValue;
                          toAmount = fromAmount;
                        });
                      },
                      items: exchangeOptions.map((Resource resource) {
                        return DropdownMenuItem<Resource>(
                          value: resource,
                          child: Row(
                            children: [
                              _buildResourceIcon(resource, 30),
                              const SizedBox(width: 10),
                              Text(resource.name),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    if (selectedResource != null) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: 'Amount to receive',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              controller: TextEditingController(
                                  text: toAmount.toStringAsFixed(2)),
                              onChanged: (value) {
                                toAmount = double.tryParse(value) ?? 1;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          _buildResourceIcon(selectedResource!, 60),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: selectedResource != null
                      ? () {
                          final success = gameProvider.exchangeResources(
                            resource.name,
                            selectedResource!.name,
                            fromAmount,
                            toAmount,
                          );

                          if (success) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Successfully exchanged resources!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            setState(() {});
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Failed to exchange resources. Not enough ${resource.name}?'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      : null,
                  child: const Text('Exchange'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildResourceIcon(Resource resource, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: resource.color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(
          color: resource.color,
          width: 2,
        ),
      ),
      child: Center(
        child: Image.asset(
          resource.imagePath,
          width: size * 0.6,
          height: size * 0.6,
          errorBuilder: (_, __, ___) =>
              Icon(Icons.monetization_on, size: size * 0.6),
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }

  String _getResourceDescription(String name) {
    switch (name) {
      case 'Gold':
        return 'Standard currency for most transactions';
      case 'Gem':
        return 'Premium currency for special purchases';
      case 'Stamina':
        return 'Energy required for battles';
      case 'Dungeon Key':
        return 'Required for dungeon battles';
      case 'Arena Ticket':
        return 'Required for arena battles';
      case 'Raid Ticket':
        return 'Required for raid battles';
      case 'Skill Book':
        return 'Used to upgrade character skills';
      case 'Awakening Shard':
        return 'For character awakening';
      case 'Enhancement Stone':
        return 'Used to enhance equipment';
      case 'Forge Material':
        return 'Basic forging material';
      case 'Girl Scroll':
        return 'Used to summon characters';
      case 'Equipment Chest':
        return 'Contains random equipment';
      default:
        return 'Valuable resource with various uses';
    }
  }
}
