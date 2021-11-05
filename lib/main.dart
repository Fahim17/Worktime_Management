import 'package:WorktimeManagement/settings.dart';
import 'package:WorktimeManagement/timermodel.dart';
import 'package:WorktimeManagement/widgets.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import './timer.dart';

void main() => runApp(MyApp());

final CountDownTimer timer = CountDownTimer();

final double defaultPadding = 5.0;

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    timer.startWork();

    return MaterialApp(
      title: 'My Work Timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TimerHomePage(),
    );
  }
}

class TimerHomePage extends StatelessWidget {
  void goToSettings(BuildContext context) {
    print('in gotoSettings');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final List<PopupMenuItem<String>> menuItems = List<PopupMenuItem<String>>();
    menuItems.add(PopupMenuItem(
      value: 'Settings',
      child: Text('Settings'),
    ));

    return Scaffold(
        appBar: AppBar(
          title: Text('Work Timer'),
          actions: [
            PopupMenuButton<String>(
              itemBuilder: (BuildContext context) {
                return menuItems.toList();
              },
              onSelected: (s) {
                if (s == 'Settings') {
                  goToSettings(context);
                }
              },
            ),
          ],
        ),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          final double availableWidth = constraints.maxWidth;

          return Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                  Expanded(
                      child: ProductivityButton(
                          color: Color(0xff009688),
                          text: "Work",
                          onPressed: timer.startWork)),
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                  Expanded(
                      child: ProductivityButton(
                          color: Color(0xff607D8B),
                          text: "Short Break",
                          onPressed: () => timer.startBreak(true))),
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                  Expanded(
                      child: ProductivityButton(
                    color: Color(0xff455A64),
                    text: "Long Break",
                    onPressed: () => timer.startBreak(false),
                  )),
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                ],
              ),
              Expanded(
                  child: StreamBuilder(
                      initialData: '00:00',
                      stream: timer.stream(),
                      builder: (context, snapshot) {
                        TimerModel timer = (snapshot.data == '00:00')
                            ? TimerModel('00:00', 1)
                            : snapshot.data;
                        return CircularPercentIndicator(
                          radius: availableWidth / 2,
                          lineWidth: 10.0,
                          percent: timer.percent,
                          center: Text(timer.time,
                              style: Theme.of(context).textTheme.headline4),
                          progressColor: Color(0xff099608),
                        );
                      })),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                  Expanded(
                      child: ProductivityButton(
                    color: Colors.redAccent,
                    text: "Stop",
                    onPressed: timer.stopTimer,
                  )),
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                  Expanded(
                      child: ProductivityButton(
                    color: Colors.green,
                    text: "Start",
                    onPressed: timer.startTimer,
                  )),
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                ],
              ),
            ],
          );
        }));
  }
}

void emptyMethod() {}
