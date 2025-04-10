import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:idle_space_farm/repositories/ability_repository.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';
import 'models/ability_scroll_model.dart';
import 'models/floor_model.dart';
import 'models/potion_model.dart';
import 'models/resource_model.dart';
import 'models/farm_model.dart';
import 'models/ability_model.dart';
import 'models/girl_farmer_model.dart';
import 'models/equipment_model.dart';
import 'models/enemy_model.dart'; // Import Enemy model
import 'models/shop_model.dart';
import 'providers/game_provider.dart';
import 'providers/battle_provider.dart'; // Import BattleProvider
import 'repositories/farm_repository.dart';
import 'repositories/potion_model.dart';
import 'repositories/resource_repository.dart';
import 'repositories/equipment_repository.dart';
import 'repositories/girl_repository.dart'; // Import EnemyRepository
import 'pages/navigationbar.dart';
import 'pages/gacha_page.dart';
import 'pages/girl_list_page.dart';
import 'repositories/shop_repository.dart';

class ImageCacheManager {
  static final Map<String, ImageProvider> _cache = {};
  static final Map<String, Uint8List> _memoryCache = {};

  static Future<void> preloadAndCache(BuildContext context) async {
    List<String> images = [
      'assets/images/ui/castle.png',
      'assets/images/icons/achievements.png',
      'assets/images/icons/reward.png',
      'assets/images/icons/battle.png',
      'assets/images/icons/settings.png',
      'assets/images/icons/farm.png',
      'assets/images/ui/app-bg.png',
      'assets/images/ui/mine.png',
      'assets/images/map/eldoria_map.png',
    ];
    for (var img in images) {
      final byteData = await rootBundle.load(img);
      _memoryCache[img] = byteData.buffer.asUint8List();
      _cache[img] = MemoryImage(_memoryCache[img]!);
      precacheImage(_cache[img]!, context);
    }
  }

  static ImageProvider getImage(String path) {
    if (_cache.containsKey(path)) {
      return _cache[path]!;
    }
    // Fallback to AssetImage if not preloaded
    return AssetImage(path);
  }

  static void clearCache() {
    _cache.clear();
    _memoryCache.clear();
    PaintingBinding.instance.imageCache.clear();
  }
}

void main() async {
  debugPrintRebuildDirtyWidgets =
      false; // Optional: disable rebuild debug prints
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

  // Clear Hive data (for development only)
  await clearHiveData();

  // Register Hive adapters safely (check if already registered)
  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(ResourceAdapter());
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(FarmAdapter());
  if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(GirlFarmerAdapter());
  if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(EquipmentAdapter());
  if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(FloorAdapter());
  if (!Hive.isAdapterRegistered(6)) {
    Hive.registerAdapter(AbilitiesModelAdapter());
  }
  if (!Hive.isAdapterRegistered(7)) Hive.registerAdapter(AbilityTypeAdapter());
  if (!Hive.isAdapterRegistered(8)) Hive.registerAdapter(TargetTypeAdapter());
  if (!Hive.isAdapterRegistered(9)) Hive.registerAdapter(StatusEffectAdapter());
  if (!Hive.isAdapterRegistered(10)) {
    Hive.registerAdapter(ControlEffectAdapter());
  }
  if (!Hive.isAdapterRegistered(11)) {
    Hive.registerAdapter(ControlEffectTypeAdapter());
  }

  if (!Hive.isAdapterRegistered(12)) {
    Hive.registerAdapter(ElementTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(13)) {
    Hive.registerAdapter(EquipmentAdapter());
  }

  if (!Hive.isAdapterRegistered(14)) {
    Hive.registerAdapter(EquipmentRarityAdapter());
  }

  if (!Hive.isAdapterRegistered(15)) {
    Hive.registerAdapter(EquipmentSlotAdapter());
  }
  if (!Hive.isAdapterRegistered(16)) {
    Hive.registerAdapter(WeaponTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(17)) {
    Hive.registerAdapter(ArmorTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(18)) {
    Hive.registerAdapter(AccessoryTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(19)) {
    Hive.registerAdapter(AbilityScrollAdapter());
  }
  if (!Hive.isAdapterRegistered(20)) {
    Hive.registerAdapter(ScrollRarityAdapter());
  }
  if (!Hive.isAdapterRegistered(21)) {
    Hive.registerAdapter(PotionAdapter());
  }
  if (!Hive.isAdapterRegistered(22)) {
    Hive.registerAdapter(PotionRarityAdapter());
  }
  if (!Hive.isAdapterRegistered(23)) {
    Hive.registerAdapter(ShopModelAdapter());
  }
  if (!Hive.isAdapterRegistered(24)) {
    Hive.registerAdapter(ShopCategoryAdapter());
  }
  if (!Hive.isAdapterRegistered(25)) {
    Hive.registerAdapter(ShopItemAdapter());
  }
  if (!Hive.isAdapterRegistered(26)) {
    Hive.registerAdapter(ShopItemTypeAdapter());
  }

  // Open the main Hive boxes
  final box = await Hive.openBox('idle_space_farm');

  // Initialize repositories
  final resourceRepository = ResourceRepository(box);
  final farmRepository = FarmRepository(box);
  final equipmentRepository = EquipmentRepository(box);
  final girlRepository = GirlRepository(box); // Initialize EnemyRepository
  final abilityRepository = AbilityRepository(box);
  final shopRepository = ShopRepository(box);
  final potionRepository = PotionRepository(box);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GameProvider(
            resourceRepository: resourceRepository,
            farmRepository: farmRepository,
            equipmentRepository: equipmentRepository,
            girlRepository: girlRepository,
            abilityRepository: abilityRepository,
            shopRepository: shopRepository,
            potionRepository: potionRepository,
          )..loadGame(),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              BattleProvider(// Pass EnemyRepository to BattleProvider
                  ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

Future<void> clearHiveData() async {
  await Hive.deleteBoxFromDisk(
      'idle_space_farm'); // Clear enemy box if it exists
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Idle Space Farm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AppLifecycleWrapper(),
      routes: {
        '/gacha-page': (context) => GachaMainPage(),
        '/manage-girls': (context) => ManageGirlListPage(),
      },
    );
  }
}

class AppLifecycleWrapper extends StatefulWidget {
  @override
  _AppLifecycleWrapperState createState() => _AppLifecycleWrapperState();
}

class _AppLifecycleWrapperState extends State<AppLifecycleWrapper>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ImageCacheManager.preloadAndCache(context);
    });

    Future.microtask(
        () => Provider.of<GameProvider>(context, listen: false).onAppStart());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    if (state == AppLifecycleState.paused) {
      gameProvider.onAppPause();
    } else if (state == AppLifecycleState.resumed) {
      gameProvider.onAppStart();
    }
  }

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}
