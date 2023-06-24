import 'package:comic/Provider/AuthManager.dart';
import 'package:comic/Provider/ComicProvider.dart';
import 'package:comic/Provider/NavProvider.dart';
import 'package:comic/Provider/UserProvider.dart';
import 'package:comic/material-them/color_schemes.g.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final data = await AuthManager.getUserAndToken();

  runApp(ChangeNotifierProvider.value(
    value: UserProvider(data),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider<UserProvider,ComicProvider>(create: (_) => ComicProvider(''), update: (_,userProvider,comicProvider){
          final token = userProvider.token;
          return ComicProvider(token!);
        }),
        ChangeNotifierProvider(create: (context) => NavProvider()),
        // ChangeNotifierProvider(create: (context) => ComicProvider())
      ],
      child: MaterialApp(
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
          darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavProvider>(context);
    return DefaultTextStyle(
      style: GoogleFonts.orbitron(),
      child: Scaffold(
        body: navProvider.pages[navProvider.activeIndex]['page'],
        bottomNavigationBar: NavigationBar(
          selectedIndex: navProvider.activeIndex,
          destinations: [
            ...navProvider.pages
                .map(
                  (e) => NavigationDestination(
                    icon: Icon(e['icon'],size: 25,),
                    selectedIcon: Icon(e['active_icon']),
                    label: e['name'],
                  ),
                )
                .toList()
          ],
          height: 70,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          onDestinationSelected: (value) {
            navProvider.changeIndex(value);
          },
        ),
      ),
    );
  }
}
