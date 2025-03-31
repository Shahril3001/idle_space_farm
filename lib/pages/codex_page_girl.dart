import 'package:flutter/material.dart';
import '../models/ability_model.dart';
import '../models/girl_farmer_model.dart';
import '../data/girl_data.dart';

class GirlCodexPage extends StatefulWidget {
  const GirlCodexPage({super.key});

  @override
  State<GirlCodexPage> createState() => _GirlCodexPageState();
}

class _GirlCodexPageState extends State<GirlCodexPage> {
  GirlFarmer? _selectedGirl;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF35271A),
          ),
          child: SafeArea(
            child:
                _selectedGirl == null ? _buildGridList() : _buildGirlDetails(),
          ),
        ),
      ),
    );
  }

  Widget _buildGridList() {
    return Column(
      children: [
        const CustomAppBar(
          title: 'Girl Codex',
          height: 40,
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.6,
            ),
            itemCount: girlsData.length,
            itemBuilder: (context, index) {
              final girl = girlsData[index];
              return _GirlCard(
                girl: girl,
                onTap: () {
                  setState(() {
                    _selectedGirl = girl;
                  });
                },
              );
            },
          ),
        ),
        _buildBackButton(context),
      ],
    );
  }

  Widget _buildGirlDetails() {
    final girl = _selectedGirl!;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomAppBar(
          title: girl.name,
          height: 40,
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF35271A),
          ),
          child: Column(
            children: [
              Container(
                color: Colors.black.withOpacity(0.7),
                child: TabBar(
                  labelColor: const Color(0xFFCAA04D),
                  unselectedLabelColor: Colors.white70,
                  indicatorColor: const Color(0xFFCAA04D),
                  tabs: const [
                    Tab(text: 'Details'),
                    Tab(text: 'Stats'),
                    Tab(text: 'Abilities'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildDetailsTab(girl),
                    _buildStatsTab(girl),
                    _buildAbilitiesTab(girl),
                  ],
                ),
              ),
              _buildBackButtonDetail(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        // ignore: sort_child_properties_last
        child: Text("Back",
            style: TextStyle(
                color: Colors.white, fontFamily: 'GameFont', fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  Widget _buildBackButtonDetail() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedGirl = null;
          });
        },
        // ignore: sort_child_properties_last
        child: Text("Back",
            style: TextStyle(
                color: Colors.white, fontFamily: 'GameFont', fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  Widget _buildDetailsTab(GirlFarmer girl) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Hero(
            tag: 'girl-image-${girl.id}',
            child: Container(
              width: 250,
              height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage(girl.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(16),
            elevation: 5,
            color: Colors.black.withOpacity(0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStarRating(girl.stars),
                  const SizedBox(height: 15),
                  _buildAttributeRow(
                    'assets/images/icons/race.png',
                    'Race',
                    girl.race,
                  ),
                  const SizedBox(height: 10),
                  _buildAttributeRow(
                    'assets/images/icons/class.png',
                    'Class',
                    girl.type,
                  ),
                  const SizedBox(height: 10),
                  _buildAttributeRow(
                    'assets/images/icons/region.png',
                    'Region',
                    girl.region,
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Colors.white54),
                  const SizedBox(height: 10),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    girl.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsTab(GirlFarmer girl) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          _buildStatSection(girl),
          const SizedBox(height: 20),
          Card(
            margin: const EdgeInsets.all(16),
            elevation: 5,
            color: Colors.black.withOpacity(0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildAttributeRow(
                    'assets/images/icons/level.png',
                    'Level',
                    "${girl.level}",
                  ),
                  const Divider(color: Colors.white54),
                  const SizedBox(height: 10),
                  _buildAttributeRow(
                    'assets/images/icons/attack.png',
                    'Attack',
                    "${girl.attackPoints}",
                  ),
                  const SizedBox(height: 10),
                  _buildAttributeRow(
                    'assets/images/icons/defense.png',
                    'Defense',
                    "${girl.defensePoints}",
                  ),
                  const SizedBox(height: 10),
                  _buildAttributeRow(
                    'assets/images/icons/agility.png',
                    'Agility',
                    "${girl.agilityPoints}",
                  ),
                  const SizedBox(height: 10),
                  _buildAttributeRow(
                    'assets/images/icons/critical.png',
                    'Critical',
                    "${girl.criticalPoint}%",
                  ),
                  const SizedBox(height: 10),
                  _buildAttributeRow(
                    'assets/images/icons/mine.png',
                    'Mining',
                    "${(girl.miningEfficiency * 100).toStringAsFixed(1)}%",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbilitiesTab(GirlFarmer girl) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Card(
            margin: const EdgeInsets.all(16),
            elevation: 5,
            color: Colors.black.withOpacity(0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Abilities',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (girl.abilities.isEmpty)
                    Center(
                      child: Text(
                        '- None -',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    )
                  else
                    ...girl.abilities
                        .map((ability) => _buildAbilityRow(ability)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatSection(GirlFarmer girl) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatBox(
          "HP",
          girl.hp,
          girl.maxHp,
          Colors.redAccent,
          'assets/images/icons/healthp.png',
        ),
        _buildStatBox(
          "MP",
          girl.mp,
          girl.maxMp,
          Colors.blueAccent,
          'assets/images/icons/manap.png',
        ),
        _buildStatBox(
          "SP",
          girl.sp,
          girl.maxSp,
          Colors.greenAccent,
          'assets/images/icons/specialp.png',
        ),
      ],
    );
  }

  Widget _buildStatBox(
    String label,
    int value,
    int maxValue,
    Color color,
    String iconPath,
  ) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Image.asset(iconPath, width: 30, height: 30),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            width: 70,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: value / maxValue,
                backgroundColor: Colors.grey[800],
                color: color,
                minHeight: 10,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "$value / $maxValue",
            style: const TextStyle(fontSize: 13, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributeRow(String iconPath, String label, String value) {
    return Row(
      children: [
        Image.asset(iconPath, width: 24, height: 24),
        const SizedBox(width: 10),
        Text(
          "$label:",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontSize: 12, color: Colors.amberAccent),
        ),
      ],
    );
  }

  Widget _buildStarRating(int stars) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Icon(
          index < stars ? Icons.star : Icons.star_border,
          color: const Color(0xFFCAA04D),
          size: 22,
        );
      }),
    );
  }

  Widget _buildAbilityRow(AbilitiesModel ability) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 16),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                ability.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            if (ability.mpCost > 0)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      size: 14,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${ability.mpCost} MP",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
            if (ability.spCost > 0)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.bolt,
                      size: 14,
                      color: Colors.orangeAccent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${ability.spCost} SP",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.orangeAccent,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          ability.description,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
        if (ability.cooldown > 0)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              children: [
                const Icon(Icons.timer, size: 12, color: Colors.white54),
                const SizedBox(width: 4),
                Text(
                  "Cooldown: ${ability.cooldown} turns",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
        const Divider(color: Colors.white54),
      ],
    );
  }
}

class _GirlCard extends StatelessWidget {
  final GirlFarmer girl;
  final VoidCallback onTap;

  const _GirlCard({required this.girl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.black.withOpacity(0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(girl.imageFace),
            ),
            const SizedBox(height: 8),
            Text(
              girl.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontFamily: 'GameFont',
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              girl.race,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
            ),
            _buildStarRating(girl.stars),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(int stars) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Icon(
          index < stars ? Icons.star : Icons.star_border,
          color: const Color(0xFFCAA04D),
          size: 16,
        );
      }),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.height = 56.0,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: padding,
      margin: margin,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/ui/wood-ui.png"),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontFamily: 'GameFont',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black,
                blurRadius: 4,
                offset: Offset(1, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
