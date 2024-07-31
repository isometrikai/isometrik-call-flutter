
import 'package:call_qwik_example/data/data.dart';
import 'package:call_qwik_example/res/res.dart';
import 'package:call_qwik_example/utils/device_config.dart';
import 'package:call_qwik_example/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

export 'controllers/controllers.dart';
export 'data/data.dart';
export 'models/models.dart';
export 'repositories/repositories.dart';
export 'res/res.dart';
export 'utils/utils.dart';
export 'view_models/view_models.dart';
export 'views/views.dart';
export 'widgets/widgets.dart';

void main() {
  initialize();
  runApp(const MyApp());
}

void initialize() {
  WidgetsFlutterBinding.ensureInitialized();
  IsmCall.i.setup();
  Get.put(ApiWrapper(Client()));
  Get.put<DeviceConfig>(DeviceConfig()).init(AppConstants.appName);
  Get.lazyPut(PreferencesManager.new);
  Get.put(DBWrapper()).init();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        useInheritedMediaQuery: true,
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) => child!,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: Utility.hideKeyboard,
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.dark,
            theme: AppTheme.theme,
            darkTheme: AppTheme.theme,
            initialRoute: AppPages.initial,
            getPages: AppPages.pages,
            localizationsDelegates: [
              ...IsmCall.i.localizationDelegates,
            ],
          ),
        ),
      );
}
