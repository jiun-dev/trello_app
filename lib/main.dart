import 'package:flutter/material.dart';
import 'package:taskhero2/four04_page.dart';
import 'package:taskhero2/project_list_page.dart';
import 'package:taskhero2/work_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: ProjectList(),
      onGenerateRoute: onGenerateRoute,
    );
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final parts = settings.name.split('?');
    final args = parts.length == 2 ? Uri.splitQueryString(parts[1]) : null;
    String errorMessage = '필수 파라미터가 없습니다.';
    switch (parts[0]) {
      case '/projectlist':
        return MaterialPageRoute(
            settings: settings, builder: (_) => ProjectList());
      case '/workpage':
        if (args != null && args.containsKey('projectNo')) {
          return MaterialPageRoute(settings: settings,
              builder: (_) => WorkPage(int.parse(args['projectNo'])));
        }
        return MaterialPageRoute(builder: (_) => Four04Page(errorMessage));
    }
    return MaterialPageRoute(builder: (_) => Four04Page(errorMessage));
  }
}

