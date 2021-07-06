import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'package:path_provider/path_provider.dart';
import 'package:productive_monk/BLoC/bloc.dart';
import 'package:productive_monk/Screens/SubScreen/tasks_view.dart';
import 'package:productive_monk/Screens/notification_screen.dart';
import 'package:productive_monk/Screens/progress_screen.dart';
import 'package:productive_monk/Screens/projects_screen.dart';
import 'package:productive_monk/Screens/self_help.dart';
import 'package:productive_monk/constants.dart';
import 'package:provider/provider.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'BLoC/model_data.dart';
import 'Screens/home_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:sliding_up_panel/sliding_up_panel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  // var dir = await getApplicationDocumentsDirectory();
  // Hive.init(dir.path);
  // Hive.registerAdapter(AllDataAdapter());
  // await Hive.openBox<AllData>("AllData");

  await _openBox();

  runApp(MyApp());
}

List<Box> boxList = [];
Future<List<Box>> _openBox() async {
  var dir = await getApplicationDocumentsDirectory();
  Hive
    ..init(dir.path)
    ..registerAdapter(ProjectBlueprintAdapter())
    ..registerAdapter(RemindersBlueprintAdapter())
    ..registerAdapter(NotesBlueprintAdapter())
    ..registerAdapter(NotificationsBlueprintAdapter())
    ..registerAdapter(MiscAdapter())
    ..registerAdapter(TasksAdapter());

  Box a = await Hive.openBox<ProjectBlueprint>("ProjectBlueprint"); //0
  // a.clear();
  Box b = await Hive.openBox<RemindersBlueprint>("RemindersBlueprint"); //1
  Box c = await Hive.openBox<NotesBlueprint>("NotesBlueprint"); //2
  Box d =
      await Hive.openBox<NotificationsBlueprint>("NotificationsBlueprint"); //3
  Box e = await Hive.openBox<Misc>("Misc"); //4
  Box f = await Hive.openBox<Tasks>("Tasks"); //5
  // f.clear();

  Box etcBox = await Hive.openBox("allDataBox");

  boxList..add(a)..add(b)..add(c)..add(d)..add(e)..add(f)..add(etcBox);
  // boxList.add(box_comment);
  return boxList;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: BLoC())],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: cBackgroundColor,
            accentColor: cPrimaryColor,
            backgroundColor: cBackgroundColor,
            scaffoldBackgroundColor: cBackgroundColor,
          ),
          home: Consumer<BLoC>(builder: (context, bl, child) {
            return boxList[6].get("showStartScreen") ?? true
                ? StartScreen()
                : HomeWidget();
          })

          //HomeWidget(),
          ),
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({
    Key? key,
  }) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  // int currentPage = 0;
  final List<Widget> allPages = [
    HomeScreen(),
    ProjectsScreen(),
    SelfHelp(),
    NotificationWidget(),
    ProgressScreen()
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BLoC bl = Provider.of<BLoC>(context, listen: false);
    String _whatToAdd() {
      if (bl.currentPageIndex == 0) {
        if (bl.currentScreenIndex == 0) {
          return "TODO";
        } else if (bl.currentScreenIndex == 1) {
          return "Reminder";
        } else {
          return "Task";
        }
      } else if (bl.currentPageIndex == 1) {
        return "new Project";
      } else {
        return "";
      }
    }

    return Scaffold(
      // backgroundColor: cThemeColor,
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                bl.currentPageIndex = 3;
                setState(() {});
              },
              icon: Icon(Icons.notifications))
        ],
        // backgroundColor: cThemeColor,
        leading: Image.asset(
          avatars[boxList[4].values.cast<Misc>().first.avatarIndex],
          fit: BoxFit.cover,
        ),
        title: Text('Hello, ${boxList[4].values.cast<Misc>().first.username}'),
      ),
      body: allPages[bl.currentPageIndex],
      floatingActionButton: bl.currentPageIndex <= 1
          ? FloatingActionButton.extended(
              label: Row(
                children: [
                  Icon(Icons.add),
                  Text(_whatToAdd()),
                ],
              ),
              onPressed: () {
                showAddStuffPopup(context);

                //*?!Todo: kj
              },
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: bl.currentPageIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Projects'),
          BottomNavigationBarItem(
              icon: Icon(Icons.health_and_safety_rounded), label: "Self help"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: 'YOU'),
        ],
        showSelectedLabels: true,
        showUnselectedLabels: false,
        backgroundColor: cBackgroundColor,
        elevation: 0,
        selectedItemColor: cThemeColor,
        unselectedItemColor: cPrimaryColor,
        onTap: (index) {
          setState(() {
            bl.currentPageIndex = index;
          });
        },
      ),
    );
  }
}

final TextEditingController unTex = new TextEditingController();

class StartScreen extends StatelessWidget {
  StartScreen({Key? key}) : super(key: key);
  final ScrollController sc = new ScrollController();
  final List<PageViewModel> listPagesViewMode = [
    PageViewModel(
      title: "Be Productive",
      body: "Focus on being productive instead of busy.",
      image: Center(
        child: Image.asset("Assets/beProductive.png"),
      ),
      decoration: PageDecoration(
          titleTextStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
          bodyTextStyle: aLittleBetter),
    ),
    PageViewModel(
      title: "Keep Your head Clear",
      body:
          "It's not always that we need to do more but rather that we need to focus on less.",
      image: Center(
        child: Image.asset("Assets/stayOrganized.png"),
      ),
      decoration: PageDecoration(
          titleTextStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
          bodyTextStyle: aLittleBetter),
    ),
    PageViewModel(
      title: "Manage Your TIME",
      body:
          "Tell us about your tasks and projects and let us help you manage them and remind you of their deadlines...",
      image: Center(
        child: Image.asset("Assets/TimeManage.png"),
      ),
      decoration: PageDecoration(
          titleTextStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
          bodyTextStyle: aLittleBetter),
    ),
    PageViewModel(
        title: "Please choose your Favorite Avatar",
        decoration: PageDecoration(
          pageColor: cPrimaryColor,
          bodyAlignment: Alignment.topCenter,
          titleTextStyle: aLittleBetter,
        ),
        bodyWidget: SizedBox(
          height: 500,
          child: StatefulBuilder(
            builder: (BuildContext context, setState) {
              return GridView.count(
                crossAxisCount: 4,
                children: List.generate(
                    9,
                    (index) => Container(
                          decoration: BoxDecoration(
                              border: index ==
                                      boxList[4]
                                          .values
                                          .cast<Misc>()
                                          .first
                                          .avatarIndex
                                  ? Border.all(color: Colors.red, width: 10)
                                  : null,
                              borderRadius: BorderRadius.circular(50)),
                          child: GestureDetector(
                            onTap: () {
                              Misc gl = boxList[4].values.cast<Misc>().first;
                              gl.avatarIndex = index;

                              boxList[4].putAt(0, gl);
                              setState(() {});
                              Provider.of<BLoC>(context, listen: false).jnl();
                            },
                            child: Image.asset(
                              avatars[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
              );
            },
          ),
        ),
        image: Consumer<BLoC>(builder: (context, bl, child) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    avatars[boxList[4].values.cast<Misc>().first.avatarIndex],
                    fit: BoxFit.cover,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        boxList[4].values.cast<Misc>().first.username ==
                                "awesome user"
                            ? "choose an username"
                            : boxList[4].values.cast<Misc>().first.username,
                        style: aLittleBetter,
                      ),
                      IconButton(
                          onPressed: () {
                            Misc gl = boxList[4].values.cast<Misc>().first;
                            gl.username = "awesome user";
                            boxList[4].putAt(0, gl);

                            Provider.of<BLoC>(context, listen: false).jnl();
                          },
                          icon: Icon(Icons.edit))
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: boxList[4].values.cast<Misc>().first.username ==
                            "awesome user"
                        ? TextField(
                            controller: unTex,
                            onSubmitted: (v) {
                              v = v == "" ? "Awesome user" : v;
                              Misc gl = boxList[4].values.cast<Misc>().first;
                              gl.username = v;
                              boxList[4].putAt(0, gl);
                              unTex.clear();
                              Provider.of<BLoC>(context, listen: false).jnl();
                            },
                            decoration: InputDecoration(
                              labelText: "I am ...",
                              hintText: "Awesome user",
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          )
                        : null,
                  )
                ],
              ),
            ),
          );
        }))
  ];

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: listPagesViewMode,
      onDone: () {
        // When done button is pressed
        boxList[6].put("showStartScreen", false);

        Provider.of<BLoC>(context, listen: false).jnl();
      },
      dotsContainerDecorator: BoxDecoration(color: cPrimaryColor),
      skip: const Text("Skip"),
      next: Icon(Icons.arrow_right_alt_outlined),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Colors.black,
          color: Colors.white,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0))),
    );
  }
}
