import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:idle_space_farm/repositories/ability_repository.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';
import 'models/ability_scroll_model.dart';
import 'models/daily_reward_model.dart';
import 'models/floor_model.dart';
import 'models/potion_model.dart';
import 'models/resource_model.dart';
import 'models/farm_model.dart';
import 'models/ability_model.dart';
import 'models/girl_farmer_model.dart';
import 'models/equipment_model.dart';
import 'models/shop_model.dart';
import 'providers/game_provider.dart';
import 'providers/battle_provider.dart';
import 'repositories/dailyreward_repository.dart';
import 'repositories/farm_repository.dart';
import 'repositories/potion_repository.dart';
import 'repositories/resource_repository.dart';
import 'repositories/equipment_repository.dart';
import 'repositories/girl_repository.dart';
import 'pages/navigationbar.dart';
import 'pages/gacha_page.dart';
import 'pages/girl_list_page.dart';
import 'repositories/shop_repository.dart';

class ImageCacheManager {
  static final Map<String, ImageProvider> _cache = {};
  static final Map<String, Uint8List> _memoryCache = {};

  static Future<void> preloadAndCache(BuildContext context) async {
    List<String> images = [
      'assets/images/icons/nav-reward.png',
      'assets/images/icons/page-start.png',
      'assets/images/icons/nav-settings.png',
      'assets/images/icons/nav-farm.png',
      'assets/images/ui/app-bg.png',
      'assets/images/icons/nav-farm.png',
      'assets/images/icons/nav-shop.png',
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
    return AssetImage(path);
  }

  static void clearCache() {
    _cache.clear();
    _memoryCache.clear();
    PaintingBinding.instance.imageCache.clear();
  }
}

void main() async {
  debugPrintRebuildDirtyWidgets = false;
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

  // Register Hive adapters
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
  if (!Hive.isAdapterRegistered(12)) Hive.registerAdapter(ElementTypeAdapter());
  if (!Hive.isAdapterRegistered(13)) Hive.registerAdapter(EquipmentAdapter());
  if (!Hive.isAdapterRegistered(14)) {
    Hive.registerAdapter(EquipmentRarityAdapter());
  }
  if (!Hive.isAdapterRegistered(15)) {
    Hive.registerAdapter(EquipmentSlotAdapter());
  }
  if (!Hive.isAdapterRegistered(16)) Hive.registerAdapter(WeaponTypeAdapter());
  if (!Hive.isAdapterRegistered(17)) Hive.registerAdapter(ArmorTypeAdapter());
  if (!Hive.isAdapterRegistered(18)) {
    Hive.registerAdapter(AccessoryTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(19)) {
    Hive.registerAdapter(AbilityScrollAdapter());
  }
  if (!Hive.isAdapterRegistered(20)) {
    Hive.registerAdapter(ScrollRarityAdapter());
  }
  if (!Hive.isAdapterRegistered(21)) Hive.registerAdapter(PotionAdapter());
  if (!Hive.isAdapterRegistered(22)) {
    Hive.registerAdapter(PotionRarityAdapter());
  }
  if (!Hive.isAdapterRegistered(23)) Hive.registerAdapter(ShopModelAdapter());
  if (!Hive.isAdapterRegistered(24)) {
    Hive.registerAdapter(ShopCategoryAdapter());
  }
  if (!Hive.isAdapterRegistered(25)) Hive.registerAdapter(ShopItemAdapter());
  if (!Hive.isAdapterRegistered(26)) {
    Hive.registerAdapter(ShopItemTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(27)) Hive.registerAdapter(DailyRewardAdapter());

  // Open the main Hive box
  final box = await Hive.openBox('eldoria_chronicles');

  // Initialize repositories
  final resourceRepository = ResourceRepository(box);
  final farmRepository = FarmRepository(box);
  final equipmentRepository = EquipmentRepository(box);
  final girlRepository = GirlRepository(box);
  final abilityRepository = AbilityRepository(box);
  final shopRepository = ShopRepository(box);
  final potionRepository = PotionRepository(box);
  final dailyRewardRepository = DailyRewardRepository(box);

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
            dailyRewardRepository: dailyRewardRepository,
          )..loadGame(),
        ),
        ChangeNotifierProvider(
          create: (_) => BattleProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eldoria Chronicles Idle RPG',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF0A0A20),
      ),
      home: const SplashScreen(),
      routes: {
        '/gacha-page': (context) => GachaMainPage(),
        '/manage-girls': (context) => ManageGirlListPage(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  double _loadingProgress = 0;
  bool _showStartButton = false;
  bool _initializationComplete = false;
  bool _minimumTimeElapsed = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );

    // Start animations
    _animationController.forward();

    // Start initialization
    _initializeApp();

    // Ensure splash screen shows for minimum time
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _minimumTimeElapsed = true);
      _checkCanProceed();
    });
  }

  Future<void> _initializeApp() async {
    const totalSteps = 5;

    try {
      for (int i = 1; i <= totalSteps; i++) {
        // Update progress immediately
        setState(() => _loadingProgress = i / totalSteps);

        // Add debug print
        debugPrint('Starting initialization step $i');

        // Perform initialization with timeout
        await _performInitializationStep(i).timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            debugPrint('Timeout on step $i');
            throw Exception('Initialization timed out on step $i');
          },
        );

        debugPrint('Completed step $i');
      }

      setState(() => _initializationComplete = true);
      _checkCanProceed();
    } catch (e) {
      debugPrint('Initialization failed: $e');
      // Handle error - maybe show a retry button
      setState(() {
        _loadingProgress = 0;
        _showStartButton = false;
        _initializationComplete = false;
      });
      _showErrorDialog(e.toString());
    }
  }

  Future<void> _performInitializationStep(int step) async {
    switch (step) {
      case 1:
        return await _loadCoreData();
      case 2:
        return await _initializeGameServices();
      case 3:
        return await _cacheGameAssets();
      case 4:
        return await _setupInitialGameState();
      case 5:
        return await _finalInitialization();
      default:
        return Future.value();
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Initialization Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _initializeApp(); // Retry
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Future<void> _loadCoreData() async {
    // Load essential game data
  }

  Future<void> _initializeGameServices() async {
    // Initialize game services
  }

  Future<void> _cacheGameAssets() async {
    // Pre-cache images
    await ImageCacheManager.preloadAndCache(context);
  }

  Future<void> _setupInitialGameState() async {
    // Setup initial game state
  }

  Future<void> _finalInitialization() async {
    // Final checks and setup
  }

  void _checkCanProceed() {
    if (_initializationComplete && _minimumTimeElapsed) {
      setState(() => _showStartButton = true);
    }
  }

  void _startGame() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 1200),
        opaque: false,
        barrierColor: Colors.transparent,
        pageBuilder: (_, __, ___) => const AppLifecycleWrapper(),
        transitionsBuilder: (_, animation, __, child) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Starfield zoom-out
              ScaleTransition(
                scale: Tween<double>(begin: 1.0, end: 15.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: const Interval(0.0, 0.6, curve: Curves.easeInQuad),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [Colors.blue.shade900, Colors.black],
                      stops: const [0.1, 1.0],
                      radius: 0.8,
                    ),
                  ),
                ),
              ),
              // Content fade-in
              FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
                  ),
                ),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
                    ),
                  ),
                  child: child,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Space background
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: ImageCacheManager.getImage(
                    'assets/images/ui/splashscreen.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: CustomPaint(
              painter: _StarFieldPainter(),
            ),
          ),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated logo
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Image.asset(
                      'assets/images/ui/eldoria_chronicles_logo.png',
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                  ),
                ),
                const Text(
                  'v1.0.0',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 10),

                // Loading indicator or start button
                if (!_showStartButton)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Column(
                      children: [
                        LinearProgressIndicator(
                          value: _loadingProgress,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'LOADING... ${(_loadingProgress * 100).toInt()}%',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                if (_showStartButton)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: 300,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            ui.Color(0xFF30A528), // Vibrant red top
                            ui.Color(0xFF155710), // Deep red bottom
                          ],
                          stops: [0.0, 0.8],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green[900]!.withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _startGame,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'START ADVENTURE',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'GameFont',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.8,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                blurRadius: 2,
                                offset: Offset(1, 1),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 40),

                // Version info
              ],
            ),
          ),
          const Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '© 2025 Eldoria Chronicles Idle RPG',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          // Copyright text
          const Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '© 2025 Eldoria Chronicles Idle RPG',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StarFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final random = Random(42); // Fixed seed for consistent stars

    // Draw 200 stars
    for (int i = 0; i < 200; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.5;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AppLifecycleWrapper extends StatefulWidget {
  const AppLifecycleWrapper({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
    return const HomePage();
  }
}
