import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';
import 'models/floor_model.dart';
import 'models/resource_model.dart';
import 'models/farm_model.dart';
import 'models/girl_farmer_model.dart';
import 'models/equipment_model.dart';
import 'providers/game_provider.dart';
import 'repositories/farm_repository.dart';
import 'repositories/resource_repository.dart';
import 'repositories/item_repository.dart';
import 'repositories/girl_repository.dart';
import 'pages/home_page.dart';
import 'pages/gacha_page.dart';
import 'pages/girl_list_page.dart';

void main() async {
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

  // Open the main Hive box
  final box = await Hive.openBox('idle_space_farm');

  // Initialize repositories
  final resourceRepository = ResourceRepository(box);
  final farmRepository = FarmRepository(box);
  final equipmentRepository = EquipmentRepository(box);
  final girlRepository = GirlRepository(box);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GameProvider(
            resourceRepository: resourceRepository,
            farmRepository: farmRepository,
            equipmentRepository: equipmentRepository,
            girlRepository: girlRepository,
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

Future<void> clearHiveData() async {
  await Hive.deleteBoxFromDisk('idle_space_farm');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
