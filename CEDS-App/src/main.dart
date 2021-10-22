import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:mysql1/mysql1.dart' as mysql;

import 'dart:io';
import 'dart:async';

import 'global.dart' as global;

void main() {
  runApp(CEDS());
}

class CEDS extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CESD',
      theme: global.themeDark,
      home: Loading(),
    );
  }

}

class Loading extends StatefulWidget {
  const Loading({Key key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();

    final PreferencesStorage storage = PreferencesStorage();

    storage.readPreferences(0).then((String value){
      setState(() {
        global.themeId = int.parse(value);
      });
    });

    storage.readPreferences(1).then((String value) async {
      setState((){
        global.coreIP = value;
        connect();
      });
    });

  }

  Future connect() async {

    try {

      global.conn =
      await mysql.MySqlConnection.connect(mysql.ConnectionSettings(
          host: global.coreIP,
          port: 3306,
          user: 'app',
          password: 'wUYzH7mi',
          db: 'Core'));

      await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => HomePage())
      );
    }
    catch(OSError) {
      setState(() {
        global.connErr = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Spacer(),
              Container(
                child: Text("CEDS-App", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              ),
              Image.asset("res/icons/ceds.png", height: 250, width: 250,),
              Container(
                child: Text("Your house in the palm of your hand", style: TextStyle(fontSize: 20)),
              ),
              Spacer(),
              infoOrError(),
              Spacer()
            ],
          ),
        ),
      )
    );
  }

  Widget infoOrError() {
    if (global.connErr == true) {

      final IPcontroller = TextEditingController();

      IPcontroller.text = global.coreIP;

      final PreferencesStorage storage = PreferencesStorage();

      return Column(
        children: [
          Text("An error occurred while trying to connect to the\nCEDS-Core database.\nCheck if the IP is correct:", style: TextStyle(fontSize: 15), textAlign: TextAlign.center,),
          Row(
            children:[
              Spacer(),
              Container(
                  width: 170,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: IPcontroller,
                    textAlign: TextAlign.center,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      hintText: IPcontroller.text != '' ? IPcontroller.text : global.coreIP,
                    ),
                    onChanged: (value) {
                      global.coreIP = value;
                    },
                  )
              ),
              Spacer(),
              ElevatedButton(
                  onPressed: (){
                    storage.writePreferences(1, global.coreIP);
                    connect();
                    setState(() {
                      global.connErr = false;
                    });
                  },
                  child: Text("Try again!")
              ),
              Spacer()
            ]
          )
        ],
      );
    }
    else {
      return Container(
          child: Text("Connecting to CEDS-core and loading your preferences...", style: TextStyle(fontSize: 14))
      );
    }
  }

}


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  int _routeIndex = 2;

  @override
  Widget build(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          AppBar(
            title: Text("CEDS", style: TextStyle(fontSize: 40)),
            toolbarHeight: MediaQuery.of(context).size.height / 10,
            actions: [
              _settingsButton()
            ],
            automaticallyImplyLeading: false,
          ),
          Container(
            height: (MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height / 10)) - 24,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Container(
                  height: (MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height / 10)) - 24,
                  width: MediaQuery.of(context).size.width / 4,
                  child: _sideBar()
                ),
                Container(
                  height: (MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height / 10)) - 24,
                  width: (MediaQuery.of(context).size.width / 4) * 3,
                  child: _sortRoute(),
                )
              ]
            )
          )
        ]
      )
    );

  }

  Widget _settingsButton(){

    return IconButton(
      icon: Icon(Icons.settings,size: 35),
      onPressed: () async {
        await Navigator.of(context).push(
           MaterialPageRoute(builder: (context) => Settings())
        );
      }
    );

  }

  double selectorPos = 309;

  Widget _sideBar(){

    return Material(
      color: Theme.of(context).colorScheme.primary,
      child: Stack( // Total sidebar height 565
        children: [
          AnimatedPositioned(
            top: selectorPos,
            child:Icon(Icons.album, size: 20,),
            duration: Duration(milliseconds: 300),
          ),
          Positioned(
            top: 63,
            right: 5,
            width: 60,
            height: 60,
            child: InkWell(
              child: Image.asset(global.icons[0], color: Colors.white,),
              onTap: () {setState(() {
                selectorPos = animSelector(0);
                _routeIndex = 0;
              });},
            )
          ),
          Positioned(
            top: 176,
            right: 5,
            width: 60,
            height: 60,
            child: InkWell(
              child: Image.asset(global.icons[1], color: Colors.white,),
              onTap: () {setState(() {
                selectorPos =  animSelector(1);
                _routeIndex = 1;
              });},
            )
          ),
          Positioned(
            top: 289,
            right: 5,
            width: 60,
            height: 60,
            child: InkWell(
              child: Image.asset(global.icons[2], color: Colors.white,),
              onTap: () {setState(() {
                selectorPos = animSelector(2);
                _routeIndex = 2;
              });},
            )
          ),
          Positioned(
            top: 402,
            right: 5,
            width: 60,
            height: 60,
            child: InkWell(
              child: Image.asset(global.icons[3], color: Colors.white,),
              onTap: () {setState(() {
                selectorPos = animSelector(3);
                _routeIndex = 3;
              });},
            )
          ),
          Positioned(
            top: 515,
            right: 5,
            width: 60,
            height: 60,
            child: InkWell(
              child: Image.asset(global.icons[4], color: Colors.white,),
              onTap: () {setState(() {
                selectorPos = animSelector(4);
                _routeIndex = 4;
              });},
            )
          ),
        ],
      )
      /*child: ListView.separated(
        separatorBuilder: (context, index) => Container(height: 65),
        physics: NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, i){
          return Container(
              height: 60,
              width: 90,
              child: ListTile(
                leading: _routeIndex == i ? Icon(Icons.album, size: 20) : Container(width: 20),
                contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                trailing: Container(
                  padding: EdgeInsets.only(right: 5),
                  width: 60,
                  height: 60,
                  child: Image.asset(global.icons[i], color: Colors.white,)
                ),
                onTap: (){
                  setState(() {
                    _routeIndex = i;
                  });
                }
              )
          );
        }
      )*/
    );
  }

  double animSelector(i) {
    double pos = 83.0 + (113.0 * i);
    return pos;
  }

  Widget _sortRoute(){

    if(global.coreIP == "ND"){
      return Scaffold(
        appBar: AppBar(
          title: Text("Setup Needed"),
          centerTitle: true,
          backgroundColor: Colors.yellow,
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Text("The CEDS-Core IP is missing \n "
              "Tap the settings icon (top left corner) and insert a valid IP address \n"
              "to establish a connection to your CEDS-Core")
        )
      );
    }
    else {
      switch (_routeIndex) {
        case 0:
          return Weather();
          break;
        case 1:
          return Clock();
          break;
        case 2:
          return Light();
          break;
        case 3:
          return Games();
          break;
        case 4:
          return Home();
          break;
        default:
          return Scaffold(
            appBar: AppBar(
              title: Text("Route Index Error"),
              centerTitle: true,
              backgroundColor: Colors.red,
              automaticallyImplyLeading: false,
            ),
          );
          break;
      }
    }

  }

}


class Weather extends StatefulWidget {
  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {

  @override
  void initState() {
    super.initState();
    _sync();
  }

  Future _sync() async {

    var result = await global.conn.query('select * from weather');

    setState(() {
      for (var row in result) {
        locationController.text = row[0];
        tempUnit = row[1];
      }
    });

  }

  Future _weatherTableQuery() async {
    await global.conn.query('update weather set location = ?, unit = ?',
        [locationController.text, tempUnit]);
  }

  final locationController = TextEditingController();

  String tempUnit = 'C';

  @override
  Widget build(BuildContext context) {
    if(global.connErr) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Connection Error"),
          backgroundColor: Colors.red,
          automaticallyImplyLeading: false,
        ),
      );
    }
    else {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Weather', style: TextStyle(fontSize: 25)),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          child: Column(
            children: [
              //Location selection textField
              Container(
                  height: 100,
                  padding: EdgeInsets.only(top: 20, right: 30, left: 30),
                  child: _locationTextField()
              ),
              //Temperature unit radio selector
              Center(
                  child: _tempUnitRadio()
              ),
              //Submit button
              Center(
                  child: Container(
                    padding: EdgeInsets.only(left: 25, right: 25, top: 25),
                    child: _submitButton(),
                  )
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _locationTextField(){

    return TextField(
      controller: locationController,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        hintText: locationController.text != '' ? locationController.text : 'Select location',
      ),
    );

  }

  Widget _tempUnitRadio(){

    List<String> tempUnits = <String>['C', 'F'];

    return Row(
      children: [
        Container(
          width: 115,
          child: ListTile(
              title: Text('C°'),
              leading: Radio(
                value: tempUnits[0],
                groupValue: tempUnit,
                onChanged: (String value){
                  setState(() {
                    tempUnit = value;
                  });
                },
              )
          ),
        ),
        Container(
          width: 115,
          child: ListTile(
            title: Text('F°'),
            leading: Radio(
              value: tempUnits[1],
              groupValue: tempUnit,
              onChanged: (String value){
                setState(() {
                  tempUnit = value;
                });
              },
            ),
          ),
        )
      ],
    );

  }

  Widget _submitButton(){
    
    return ElevatedButton(
      child: Text('Submit changes', style: TextStyle(fontSize: 25)),
      onPressed: (){
        _weatherTableQuery();
      },
    );
    
  }
  
}


class Clock extends StatefulWidget {
  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {

  bool del = false;

  int dropdownHourValue = 0;
  int dropdownMinuteValue = 0;

  @override
  Widget build(BuildContext context) {
    return _sortRoute();
  }

  Widget _sortRoute(){

    switch(global.clockRouteIndex){
      case false:
        return AlarmList();
        break;
      case true:
        return AddAlarm();
        break;
      default:
        return Scaffold(
          appBar: AppBar(
            title: Text("Route Index Error"),
            centerTitle: true,
            backgroundColor: Colors.red,
            automaticallyImplyLeading: false,
          ),
        );
        break;
    }

  }

  Widget AlarmList(){

    return Container(
      height: MediaQuery.of(context).size.height - 105,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Clock', style: TextStyle(fontSize: 25)),
          automaticallyImplyLeading: false,
        ),
        floatingActionButton: _addAlarmButton(),
        body: _alarmList(),
      ),
    );

  }

  Widget _addAlarmButton(){

    return FloatingActionButton(
      child: Icon(Icons.alarm_add),
      onPressed: () {
        setState(() {
          del = false;
          global.clockRouteIndex = true;
          if (global.alarmCount == null)
            global.alarmCount = 0;
          else
            global.alarmCount ++;
          global.alarms.add(global.Alarm());
        });
      },
    );

  }

  Widget _alarmList(){

    return Container(
        child: Column(
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.only(top: 20),
                child: Text('Active alarms:',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ),
            Container(
                height: 492,
                child: ListView.builder(
                    itemCount: global.alarmCount != null &&
                        global.alarmCount != 0
                        ? (global.alarmCount + 1) * 2
                        : 1,
                    itemBuilder: (context, index) {
                      if (global.alarmCount != null) {
                        if (index.isOdd) return Divider();
                        final i = index ~/ 2;
                        return Container(
                          child: _alarmListTile(i),
                        );
                      }
                      else
                        return Center(
                          child: Container(
                            padding: EdgeInsets.only(top: 20),
                            child: Text('No alarms set.', style: TextStyle(
                                color: Colors.white, fontSize: 20),),
                          ),
                        );
                    }
                )
            ),
          ],
        )
    );

  }

  Widget _alarmListTile(index) {

    final swValue = global.alarms[index].enabled;

    return ListTile(
      leading: Text(
          '${global.alarms[index].hour}:${global.alarms[index].minute}',
          style: TextStyle(fontSize: 20.0)),
      title: Container(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              global.alarms[index].days[0] != '' ? Text('Mo,') : Text(''),
              global.alarms[index].days[1] != '' ? Text('Tu,') : Text(''),
              global.alarms[index].days[2] != '' ? Text('We,') : Text(''),
              global.alarms[index].days[3] != '' ? Text('Th,') : Text(''),
              global.alarms[index].days[4] != '' ? Text('Fr,') : Text(''),
              global.alarms[index].days[5] != '' ? Text('Sa,') : Text(''),
              global.alarms[index].days[6] != '' ? Text('Su') : Text(''),
            ],
          ),
        ),
      ),
      trailing: !del ? Switch(
        value: swValue,
        onChanged: (value) {
          setState(() {
            global.alarms[index].enabled = value;
          });
        },
      ) : Switch(
        value: false,
        onChanged: (value) {
          setState(() {
            if (value) {
              global.alarms.remove(global.alarms[index]);
              for (int i = index + 1; i < global.alarmCount; i++) {
                global.alarms[i - 1] = global.alarms[i];
              }
              if (global.alarmCount == 0)
                global.alarmCount = null;
              else
                global.alarmCount --;
            }
          });
        },
      ),
      onLongPress: () {
        setState(() {
          del = !del;
        });
      },
    );

  }


  Widget AddAlarm(){

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Alarm', style: TextStyle(fontSize: 25)),
        leading:  _abortButton(),
        actions: [
          _confirmButton()
        ]
      ),
      body: Container(
        child: Column(
          children: [
            _alarmHourSelector(),
            _dayList()
          ]
        )
      )
    );

  }

  Widget _confirmButton(){

    return IconButton(
        icon: Icon(Icons.alarm_on),
        onPressed: (){
          print('Hour: ${global.alarms[global.alarmCount].hour}, Minute: ${global.alarms[global.alarmCount].minute}, Days: ${global.alarms[global.alarmCount].days}');
          setState(() {
            global.alarms[global.alarmCount].hour = dropdownHourValue;
            global.alarms[global.alarmCount].minute = dropdownMinuteValue;
            global.alarms[global.alarmCount].enabled = true;
            global.clockRouteIndex = false;
          });
        }
    );

  }

  Widget _alarmHourSelector(){

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        //Alarm time selector
        Container(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 2),
          child: Row(
              children: [
                _dropDownHourSelector(),
                //':' text
                Container(
                  child: Text(':', style: TextStyle(fontSize: 30.0)),
                ),
                _dropDownMinuteSelector(),
              ]
          )
        ),
        Spacer()
      ]
    );

  }

  Widget _dropDownHourSelector(){
    return Container(
      child: DropdownButton <int>(
        style: TextStyle(fontSize: 30.0),
        value: dropdownHourValue,
        iconSize: 30,
        underline: Container(
          height: 2,
        ),
        items: <int>[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]
            .map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text('$value'),
          );
        }).toList(),
        onChanged: (int newValue) {
          setState(() {
            dropdownHourValue = newValue;
          });
        },
      ),
    );
  }

  Widget _dropDownMinuteSelector(){

    return Container(
      child: DropdownButton <int>(
        style: TextStyle(fontSize: 30.0),
        value: dropdownMinuteValue,
        iconSize: 30,
        underline: Container(
          height: 2,
        ),
        items: <int>[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59]
            .map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text('$value'),
          );
        }).toList(),
        onChanged: (int newValue) {
          setState(() {
            dropdownMinuteValue = newValue;
            global.alarms[global.alarmCount].minute = dropdownMinuteValue;
          });
        },
      ),
    );

  }


  Widget _dayList(){

    return Container(
        height: 480,
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: 13,
            itemBuilder: (context, index) {
              if (index.isOdd) return Divider();
              final i = index ~/ 2;
              return Container(
                child: _dayListTile(i),
              );
            }
        )
    );

  }

  Widget _dayListTile(day){

    final List<String> days = <String>['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    if (global.alarms[global.alarmCount].days == null ) global.alarms[global.alarmCount].days = <String>['','','','','','',''];
    final swValue = global.alarms[global.alarmCount].days.contains(days[day]);

    return ListTile(
      title: Text(days[day]),
      trailing: Switch(
        value: swValue,
        onChanged: (value){
          setState(() {
            if (swValue) global.alarms[global.alarmCount].days[day] = '';
            else global.alarms[global.alarmCount].days[day] = days[day];
          });
        },
      ),
    );
  }

  Widget _abortButton(){

    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: (){
          setState(() {
            global.clockRouteIndex = false;
            global.alarms[global.alarmCount].days = null;
            if(global.alarmCount == 0) global.alarmCount = null;
            else global.alarmCount --;
            global.alarms.remove(global.Alarm());
          });
        }
    );

  }

}


class Light extends StatefulWidget {
  @override
  _LightState createState() => _LightState();
}

class _LightState extends State<Light> {

  @override
  void initState() {
    super.initState();
    _sync();
  }

  Future _sync() async {


      var result = await global.conn.query('select * from light');

      setState(() {
        for (var row in result) {
          if (row[3] == 'Static') {
            _ledSwitchIndex = row[0] == 0 ? 1 : 0;
            currentColor = Color(
                int.parse(row[1].substring(0, 6), radix: 16) + 0xFF000000);
            _currentSliderValue = row[2].toDouble();
          }
          else {
            if (row[2] == 0) {
              currentColors.add(Color(
                  int.parse(row[1].substring(0, 6), radix: 16) + 0xFF000000));
            }
            else {
              _ledSwitchIndex = row[0];
              currentColors.add(Color(
                  int.parse(row[1].substring(0, 6), radix: 16) + 0xFF000000));
              _currentSliderValue = row[2].toDouble();
              dropdownEffectValue = row[3];
            }
          }
        }
      });
  }

  Future _lightTableQuery() async {
    setState(() {
      _ledSwitchIndex = 0;
    });

    //print(colorHex);

    switch(dropdownEffectValue) {
      case 'Static':
        String colorHex = '${currentColor.value.toRadixString(16).substring(2)}';
        await global.conn.query('delete from light where brightness = 0');
        await global.conn.query(
            'update light set enabled = ? , colorHex = ? , brightness = ? , effect = ? ',
            [1, colorHex, _currentSliderValue, dropdownEffectValue]);
        break;
      case 'Breathing':
        List<String> ColorsHex = [];
        var mode;
        var results = await global.conn.query('select brightness from light');
        for (var row in results){
          if (row[0] == 0) mode = 1;
          else mode = 0;
        }
        for (int i = 0; i < currentColors.length; i ++) {
          ColorsHex.add('${currentColors[i].value.toRadixString(16).substring(2)}');
          if (mode == 0) {
            if (i == 0)
              await global.conn.query(
                  'update light set enabled = ? , colorHex = ? , brightness = ? , effect = ? ',
                  [1, ColorsHex[i], _currentSliderValue, dropdownEffectValue]);
            else
              await global.conn.query(
                  'insert into light(enabled, colorHex, brightness, effect) values( ? , ? , ? , ? ) ',
                  [Null, ColorsHex[i], Null, Null]);
          }
          else{
            if (i == 0) {
              await global.conn.query('delete from light');
              await global.conn.query(
                  'insert into light(enabled, colorHex, brightness, effect) values( ? , ? , ? , ? ) ',
                  [1, ColorsHex[i], _currentSliderValue, dropdownEffectValue]);
            }
            else
              await global.conn.query(
                  'insert into light(enabled, colorHex, brightness, effect) values( ? , ? , ? , ? ) ',
                  [Null, ColorsHex[i], Null, Null]);
          }
        }
        break;
    }
  }

  Future _ledSwitchQuery(int index) async {

    setState(() {
      _ledSwitchIndex = index;
    });

    if (index == 0)
      await global.conn.query('update light set enabled = 1');
    else
      await global.conn.query('update light set enabled = 0');

  }

  final List<Color> availableColors = <Color>[
    Color(0xffff0000),
    Color(0xffff8000),
    Color(0xffffff00),
    Color(0xff00ff00),
    Color(0xff00ffff),
    Color(0xff0000ff),
    Color(0xffbf00ff),
    Color(0xffff00ff),
  ];


  Color pickerColor = Color(0xffffffff);
  Color currentColor = Color(0xffffffff);

  List<Color> currentColors = <Color>[];

  String dropdownEffectValue = 'Static';

  double _currentSliderValue = 10;

  int _ledSwitchIndex = 1;

  bool _routeIndex = false;

  int _selectedColor = -1;

  Widget build(BuildContext context) {

    if(global.connErr){
      return Container(
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("Connection Error"),
              backgroundColor: Colors.red,
              automaticallyImplyLeading: false,
            ),
          )
      );
    }
    else {
      switch (_routeIndex) {
        case false:
          return MainPage();
          break;
        case true:
          return ColorPicker();
          break;
        default:
          return Scaffold(
            appBar: AppBar(
              title: Text("Route Index Error"),
              centerTitle: true,
              backgroundColor: Colors.red,
              automaticallyImplyLeading: false,
            ),
          );
          break;
      }
    }

  }

  Widget MainPage(){

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Light", style: TextStyle(fontSize: 25)),
        automaticallyImplyLeading: false,
      ),
      body: Column(
          children: [
            _colorSelector(),
            _brightnessSlider(),
            _effectDropDown(),
            _setButton()
          ]
      ),
      bottomNavigationBar: _ledSwitch()
    );

  }


  Widget _colorSelector(){

    return Row(
        children: [
          Container(
            padding: EdgeInsets.only(top: 20, left: 25),
            alignment: Alignment.topLeft,
            child: _colorPickerButton()
          ),
          Container(
            width: 135,
            height: 50,
            padding: EdgeInsets.only(top: 20),
            child: _colorDisplay()
          ),
        ]
    );

  }

  Widget _colorPickerButton(){

    return ElevatedButton(
        child: Text('Pick a color!'),
        onPressed: () {
          setState(() {
            _routeIndex = true;
          });
        }
    );

  }

  Widget _colorDisplay(){

    return Center(
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: currentColor,
          borderRadius: BorderRadius.all(Radius.circular(50))
        ),
      )
    );

  }


  Widget _brightnessSlider(){

    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 15),
      alignment: Alignment.topCenter,
      child: Column(
          children: [
            Text('Brightness', style: TextStyle(fontSize: 20)),
            Slider(
              value: _currentSliderValue,
              min: 10,
              max: 100,
              divisions: 100,
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                });
              },
            )
          ]
      ),
    );

  }


  Widget _effectDropDown(){

    return Container(
      padding: EdgeInsets.only(bottom: 50),
      child: DropdownButton <String>(
          style: TextStyle(fontSize: 20.0),
          value: dropdownEffectValue,
          iconSize: 30,
          underline: Container(
            height: 2,
          ),
          items: <String>['Static', 'Breathing', 'Fade', 'Waterfall']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String newValue) {
            setState(() {
              dropdownEffectValue = newValue;
            });
          }
      ),
    );

  }


  Widget _setButton(){

    return ElevatedButton(
      child: Text('Set', style: TextStyle(fontSize: 25)),
      onPressed: () {
        _lightTableQuery();
      }
    );

  }


  Widget _ledSwitch(){

    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.flash_on,),
          label: 'LEDs on',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.flash_off,),
          label: 'LEDs off',
        ),
      ],
      currentIndex: _ledSwitchIndex,
      onTap: _ledSwitchQuery,
    );

  }



  Widget ColorPicker(){

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Pick a color", style: TextStyle(fontSize: 25)),
        leading: _backButton()
      ),
      body: _colorGridBuilder()
    );

  }

  Widget _backButton(){

    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: (){
        setState(() {
          _routeIndex = false;
        });
      }
    );

  }

  Widget _colorGridBuilder(){

    return GridView.builder(
      primary: false,
      padding: const EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 70,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20
      ),
      itemCount: availableColors.length,
      itemBuilder: (context, index){
        return _colorGridTile(index);
      },
    );

  }

  Widget _colorGridTile (index){

    return InkWell(
      child:Container(
        color: availableColors[index],
        child: _selectedColor == index ? Center(
            child: Icon(Icons.check)
        ) : Container(),
      ),
      onTap: (){
        currentColor = availableColors[index];
        setState(() {
          _selectedColor = index;
        });
      },
    );

  }

}


class Games extends StatefulWidget {
  @override
  _GamesState createState() => _GamesState();
}

class _GamesState extends State<Games> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Games", style: TextStyle(fontSize: 25),),
        automaticallyImplyLeading: false,
      ),
      body: Container(
          padding: EdgeInsets.only(top: 20),
          child: _gamesGridView()
      ),
    );
  }

  Widget _gamesGridView() {

    return GridView.count(
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      crossAxisCount: 2,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Container(
            child: _tetrisTile()
        ),
        Container(
            child: _pongTile()
        ),
        Container(
          child: _wolframTile()
        )
      ],
    );

  }

  Widget _tetrisTile() {

    return InkWell(
      child: Column(
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("res/icons/tetris.jpg"),
                  fit: BoxFit.fill,
                ),
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            Center(
                child: Text("Tetris", style: TextStyle(fontSize: 20),)
            ),
          ]
      ),
      onTap: (){
        setState(() {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Tetris_Controller())
          );
        });
      },
    );

  }

  Widget _pongTile() {
    return InkWell(
      child: Column(
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("res/icons/pong.jpg"),
                  fit: BoxFit.fill,
                ),
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            Center(
                child: Text("Pong", style: TextStyle(fontSize: 20),)
            ),
          ]
      ),
      onTap: () {

      },
    );

  }

  Widget _wolframTile() {
    return InkWell(
      child: Column(
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("res/icons/wolfram.jpg"),
                  fit: BoxFit.fill,
                ),
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            Center(
                child: Text("Wolfram", style: TextStyle(fontSize: 20),)
            ),
          ]
      ),
      onTap: () {
        setState(() {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Wolfram_Controller())
          );
        });
      },
    );
  }

}

class Tetris_Controller extends StatefulWidget {
  @override
  _Tetris_ControllerState createState() => _Tetris_ControllerState();
}

class _Tetris_ControllerState extends State<Tetris_Controller> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    gameEnabler();
    Future.delayed( const Duration(milliseconds: 5000), (){
      connection();
    });
  }

  Future gameEnabler() async{

    await global.conn.query('update games set enabled = ?, game = ?' , [1, "Tetris"]);

  }

  Future gameDisabler() async{

    await global.conn.query('update games set enabled = ?, game = ?' , [0, "Tetris"]);

  }

  Socket socket;

  void connection() {

    Socket.connect(global.coreIP, 65432).then((Socket sock) {
      socket = sock;
      socket.listen(dataHandler,
        onDone: doneHandler,
      );
    });
    //Connect standard in to the socket
    //stdin.listen((data) => socket.write(new String.fromCharCodes(data).trim() + '\n'));
  }

  void dataHandler(data){
    print(new String.fromCharCodes(data).trim());
  }

  void doneHandler(){
    String command = '!DISCONNECT';
    int len = command.length;
    socket.write(len.toString());
    socket.write(command);
    socket.destroy();
    gameDisabler();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
          child: Column(
              children: [
                Row(
                    children: [
                      IconButton(
                        iconSize: 50,
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                          SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
                          doneHandler();
                          Navigator.pop(context);
                        },
                      ),
                      Spacer(),
                      Container(
                          child:Text("Tetris", style: TextStyle(fontSize:70),)
                      ),
                      Spacer(),
                    ]
                ),
                Spacer(),
                Row(
                  children: [
                    Spacer(),
                    InkWell(
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 5),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                            child: Icon(Icons.keyboard_arrow_up, size: 50,)
                        ),
                      ),
                      onTap: (){
                        String command = 'up';
                        int len = command.length;
                        socket.write(len.toString());
                        socket.write(command);
                      },
                    ),
                    Spacer(),
                    InkWell(
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 5),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                            child: Icon(Icons.keyboard_arrow_down, size: 50,)
                        ),
                      ),
                      onTap: (){
                        String command = 'down';
                        int len = command.length;
                        socket.write(len.toString());
                        socket.write(command);
                      },
                    ),
                    Spacer(),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    Spacer(),
                    InkWell(
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 5),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                            child: Icon(Icons.keyboard_arrow_left, size: 50,)
                        ),
                      ),
                      onTap: (){
                        String command = 'left';
                        int len = command.length;
                        socket.write(len.toString());
                        socket.write(command);
                      },
                    ),
                    Spacer(),
                    InkWell(
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 5),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                            child: Icon(Icons.keyboard_arrow_right, size: 50,)
                        ),
                      ),
                      onTap: (){
                        String command = 'right';
                        int len = command.length;
                        socket.write(len.toString());
                        socket.write(command);
                      },
                    ),
                    Spacer(),
                  ],
                ),
                Spacer()
              ]
          ),
        )
    );
  }
}

class Wolfram_Controller extends StatefulWidget {
  const Wolfram_Controller({Key key}) : super(key: key);

  @override
  _Wolfram_ControllerState createState() => _Wolfram_ControllerState();
}

class _Wolfram_ControllerState extends State<Wolfram_Controller> {

  String rule = "Rule110";

  @override
  void initState() {
    super.initState();
    _wolframEnabler();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Wolfram", style: TextStyle(fontSize: 25),),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            iconSize: 25,
            onPressed: () {
              _wolframDisabler();
              setState(() {
                Navigator.pop(context);
              });
            },
          ),
        ),
        body: Container(
          child: _wolframSettings()
        ),
      ),
    );
  }

  Future _wolframEnabler() async {
    final conn = await mysql.MySqlConnection.connect(mysql.ConnectionSettings(
        host: global.coreIP,
        port: 3306,
        user: 'app',
        password: 'wUYzH7mi',
        db: 'Core'
    ));

    var myresult = await conn.query(
        "update games set enabled = ?, game = ?", [1, rule]);

    await conn.close();
  }

  Future _wolframDisabler() async {
    final conn = await mysql.MySqlConnection.connect(mysql.ConnectionSettings(
        host: global.coreIP,
        port: 3306,
        user: 'app',
        password: 'wUYzH7mi',
        db: 'Core'
    ));

    var myresult = await conn.query(
        "update games set enabled = ?, game = ?", [0, rule]);

    await conn.close();
  }

  Widget _wolframSettings(){
    return Column(
      children: [
        ListTile(
          title: Text("Rule"),
          trailing: _ruleDropDown(),
        ),
      ],
    );
  }

  Widget _ruleDropDown(){
    return DropdownButton(
      value: rule,
      icon: const Icon(Icons.arrow_drop_down_outlined),
      iconSize: 24,
      onChanged: (String newValue) {
        setState(() {
          rule = newValue;
          _wolframEnabler();
        });
      },
      items: <String>['Rule110', 'Rule106', 'Custom']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

}


class Device{

  int id;
  String hostName;
  bool MWSO; //Manual Wireless State Override
  bool MPSO; //Manual Physical State Override
  bool state;
  bool RE;   //Routine Enable

  Device({this.id, this.hostName, this.MWSO, this.MPSO, this.state, this.RE});
}

class Routine{

  int id;
  int stepCount;
  List<int> hour = <int>[];
  List<int> minute = <int>[];
  List<bool> state = <bool>[];

  Routine({this.id, this.stepCount, this.hour, this.minute, this.state});
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _devicesNum = 0;

  List<Device> devices = <Device>[];

  List<bool> _expandedRoutines = <bool>[];

  List<Routine> routines = <Routine>[];

  int _route = 0;

  bool editRoutine = false;

  bool connErr = false;

  @override
  void initState(){
    super.initState();
    _sync();
  }

  Future _sync() async {

    try {
      final conn = await mysql.MySqlConnection.connect(mysql.ConnectionSettings(
          host: global.coreIP,
          port: 3306,
          user: 'app',
          password: 'wUYzH7mi',
          db: 'Core'
      ));

      var myresult = await conn.query("select * from devices");

      _devicesNum = myresult.length;

      setState(() {
        int i = 0;
        for (var row in myresult) {
          print(row);
          devices.add(Device());
          devices[i].id = row[0];
          devices[i].hostName = row[1];
          devices[i].MWSO = row[2] == 0 ? false : true;
          devices[i].MPSO = row[3] == 0 ? false : true;
          devices[i].state = row[4] == 0 ? false : true;
          devices[i].RE = row[5] == 0 ? false : true;
          _expandedRoutines.add(false);
          i = i + 1;
        }
      });

      print(routines.length);

      await conn.close();

    }
    catch(OSError) {
      setState(() {
        connErr = true;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    if(connErr){
      return Container(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Connection Error"),
            backgroundColor: Colors.red,
            automaticallyImplyLeading: false,
          ),
        )
      );
    }
    else {
      return Container(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Home", style: TextStyle(fontSize: 25),),
            automaticallyImplyLeading: false,
          ),
          bottomNavigationBar: _bottomRouterBar(),
          body: _devicePageRouter(),
        ),
      );
    }
  }

  Widget _bottomRouterBar(){

    return  BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.alt_route),
          label: "Manual override",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_tree),
          label: "Routines",
        ),
      ],
      currentIndex: _route,
      onTap: (index){
        setState(() {
          _route = index;
        });
      },
    );

  }


  Widget _devicePageRouter() {

    if (_route == 0) {
      return  _devicesList();
    }
    else {
      return _routineList();
    }

  }


  Widget _devicesList(){

    return Container(
      child: ListView.separated(
          itemBuilder: (context, index) => _devicesListItem(index),
          separatorBuilder: (context, index) => Divider(),
          itemCount: _devicesNum
      )
    );

  }

  Widget _devicesListItem(int index) {
    if (devices[index].state) {
      return ListTile(
        title: Text(devices[index].hostName),
        leading: IconButton(
          icon: Icon(Icons.lightbulb),
          onPressed: _stateOverride(index),
        ),
        trailing: Switch(
          value: devices[index].MWSO,
          onChanged: (value) {
            setState(() {
              devices[index].MWSO = value;
            });
            _MWSO(devices[index].id, value);
          },
        ),
      );
    }
    else {
      return ListTile(
        title: Text(devices[index].hostName),
        leading: IconButton(
          icon: Icon(Icons.lightbulb_outline),
          onPressed: _stateOverride(index),
        ),
        trailing: Switch(
          value: devices[index].MWSO,
          onChanged: (value) {
            setState(() {
              devices[index].MWSO = value;
            });
            _MWSO(devices[index].id, value);
          }
        ),
      );
    }
  }

  Function _stateOverride(index) {

    if (devices[index].MWSO) {
      return () {
        setState(() {
          devices[index].state = !devices[index].state;
        });
        _SO(devices[index].id, devices[index].state);
      };
    }
    else return null;
  }

  Future _MWSO(int id, bool state) async {

    final conn = await mysql.MySqlConnection.connect(mysql.ConnectionSettings(
        host: global.coreIP,
        port: 3306,
        user: 'app',
        password: 'wUYzH7mi',
        db: 'Core'
    ));

    if (state) {
      await conn.query("update devices set MWSO = 1 where id = ?", [id]);
    }
    else {
      await conn.query("update devices set MWSO = 0 where id = ?", [id]);
    }
    await conn.close();

  }

  Future _SO(int id, bool state) async {

    final conn = await mysql.MySqlConnection.connect(mysql.ConnectionSettings(
        host: global.coreIP,
        port: 3306,
        user: 'app',
        password: 'wUYzH7mi',
        db: 'Core'
    ));

    if (state) {
      await conn.query("update devices set state = 1 where id = ?", [id]);
    }
    else {
      await conn.query("update devices set state = 0 where id = ?", [id]);
    }
    await conn.close();

  }



  Widget _routineList(){

    return Container(
      child: ListView.separated(
          itemBuilder: (context, index) => _routineListItem(index),
          separatorBuilder: (context, index) => Divider(),
          itemCount: _devicesNum,
      )
    );

  }

  Widget _routineListItem(int index) {

    if(!_expandedRoutines[index]) {
      return _deviceTile(index, true);
    }
    else {
      if (index < routines.length) {
        if (editRoutine == false) {
          int routineIndex = 0;
          for (int i = 0; i < routines.length; i++) {
            if (routines[i].id == devices[index].id) {
              routineIndex = i;
              break;
            }
          }
          return _openRoutineDropDown(index, routineIndex);
        }
        else {
          return _newRoutineDropDown(index);
        }
      }
      else{
        return _newRoutineDropDown(index);
      }
    }

  }


  Widget _deviceTile(int index, bool open){
    
    if (open == true) {
      return ListTile(
        leading: Icon(Icons.arrow_right),
        title: Text(devices[index].hostName),
        trailing: Switch(
          value: devices[index].RE,
          onChanged: (value) {
            setState(() {
              devices[index].RE = value;
            });
          },
        ),
        onTap: (){
          setState(() {
            _expandedRoutines[index] = true;
          });
        },
      );
    }
    else {
      return ListTile(
        leading: Icon(Icons.arrow_drop_down),
        title: Text(devices[index].hostName),
        trailing: Switch(
          value: devices[index].RE,
          onChanged: (value) {
            setState(() {
              devices[index].RE = value;
            });
          },
        ),
        onTap: () {
          setState(() {
            _expandedRoutines[index] = false;
          });
        },
      );
    }
    
  }
  

  Widget _openRoutineDropDown(int index, int routineIndex) {

    return  Container(
      child: Column(
          children: [
            _deviceTile(index, false),
            Container(
                color: global.themeDark.colorScheme.primaryVariant,
                height: (56 * routines[routineIndex].stepCount).toDouble(),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: routines[routineIndex].stepCount,
                  itemBuilder: (context, stepIndex) =>
                      _routineStepTile(stepIndex, routineIndex),
                )
            )
          ]
      ),
    );

  }

  Widget _routineStepTile(int stepIndex, int index) {

    if(routines[index].state[stepIndex]) {
      return ListTile(
        leading: Text(stepIndex.toString()),
        title: Text(routines[index].hour[stepIndex].toString() + ":" +
            routines[index].minute[stepIndex].toString()),
        trailing: Icon(Icons.lightbulb),
      );
    }
    else {
      return ListTile(
        leading: Text(stepIndex.toString()),
        title: Text(routines[index].hour[stepIndex].toString() + ":" +
            routines[index].minute[stepIndex].toString()),
        trailing: Icon(Icons.lightbulb_outline),
      );
    }
  }
  

  Widget _newRoutineDropDown(int index) {

    return Container(
        child: Column(
            children: [
              _deviceTile(index, false),
              editRoutine ?
                _newRoutineField(index)
                    :
                _newRoutineButton(index)
            ]
        )
    );

  }

  Widget _newRoutineButton(int index) {
    return InkWell(
      child: Container(
          color: global.themeDark.colorScheme.primaryVariant,
          height: 56,
          child: Center(
              child: Icon(Icons.plus_one)
          )
      ),
      onTap: () {
        setState(() {
          editRoutine = true;
          routines.add(Routine());

          routines[routines.length-1].id = devices[index].id;
          routines[routines.length-1].stepCount = 1;
          routines[routines.length-1].state = [];
          routines[routines.length-1].state.add(false);
          dropdownHourValue.add(0);
          routines[routines.length-1].hour = [];
          dropdownMinuteValue.add(0);
          routines[routines.length-1].minute = [];
        });
      },
    );
  }
  
  Widget _newRoutineField(int index) {

    return Container(
      color: global.themeDark.colorScheme.primaryVariant,
      height: ((56 * routines[routines.length - 1].stepCount) + 56).toDouble(),
      child: Column(
        children: [
          Container(
            height: (56 * routines[routines.length - 1].stepCount).toDouble(),
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: routines[routines.length - 1].stepCount,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text(index.toString()),
                  title: _hourSelector(index),
                  trailing: _stateButton(index),
                );
              },
            )
          ),
          Container(
            height: 56,
            child: ListTile(
              title: IconButton(
                icon: Icon(Icons.plus_one),
                onPressed: (){
                  setState(() {
                    routines[routines.length-1].stepCount += 1;
                    routines[routines.length-1].state.add(false);
                    dropdownHourValue.add(0);
                    dropdownMinuteValue.add(0);
                  });
                },
              ),
              leading: IconButton(
                icon: Icon(Icons.remove),
                onPressed: (){
                  setState(() {
                    routines[routines.length - 1].stepCount -= 1;
                    if(routines[routines.length-1].stepCount >= 1) {
                      routines[routines.length - 1].state.removeAt(routines[routines.length - 1].stepCount - 1);
                    }
                    else {
                      editRoutine = false;
                      routines.removeAt(routines.length-1);
                    }
                  });
                },
              ),
              trailing: IconButton(
                icon: Icon(Icons.check),
                onPressed: (){
                  setState(() {
                    editRoutine = false;
                  });
                },
              ),
            )
          ),
        ],
      )
    );

  }
  
  Widget _hourSelector(int index) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          //Alarm time selector
          Container(
              child: Row(
                  children: [
                    _dropDownHourSelector(index),
                    //':' text
                    Container(
                      child: Text(':', style: TextStyle(fontSize: 20.0)),
                    ),
                    _dropDownMinuteSelector(index),
                  ]
              )
          ),
          Spacer()
        ]
    );

  }

  List<int> dropdownHourValue = [0];
  List<int> dropdownMinuteValue = [0];

  Widget _dropDownHourSelector(int index){
    return Container(
      child: DropdownButton <int>(
        style: TextStyle(fontSize: 20.0),
        value: dropdownHourValue[index],
        iconSize: 20,
        underline: Container(
          height: 2,
        ),
        items: <int>[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]
            .map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text('$value'),
          );
        }).toList(),
        onChanged: (int newValue) {
          setState(() {
            dropdownHourValue[index] = newValue;
            routines[routines.length-1].hour.add(newValue);
          });
        },
      ),
    );
  }

  Widget _dropDownMinuteSelector(int index){

    return Container(
      child: DropdownButton <int>(
        style: TextStyle(fontSize: 20.0),
        value: dropdownMinuteValue[index],
        iconSize: 20,
        underline: Container(
          height: 2,
        ),
        items: <int>[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59]
            .map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text('$value'),
          );
        }).toList(),
        onChanged: (int newValue) {
          setState(() {
            dropdownMinuteValue[index] = newValue;
            routines[routines.length-1].minute.add(newValue);
          });
        },
      ),
    );

  }

  Widget _stateButton(int index) {

    if (routines[routines.length-1].state[index] == false) {
      return IconButton(
        icon: Icon(Icons.lightbulb_outline),
        onPressed: () {
          setState(() {
            routines[routines.length-1].state[index] = true;
          });
        },
      );
    }
    else {
      return IconButton(
        icon: Icon(Icons.lightbulb),
        onPressed: () {
          setState(() {
            routines[routines.length-1].state[index] = false;
          });
        },
      );
    }
  }

}






class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  Future updateSettingsDb(int value) async {

    final conn = await mysql.MySqlConnection.connect(mysql.ConnectionSettings(
        host: global.coreIP,
        port: 3306,
        user: 'app',
        password: 'wUYzH7mi',
        db: 'Core'));

    await conn.query('update settings set brightness = ?',[value]);

    await conn.close();

  }

  Future _sync() async {

    final conn = await mysql.MySqlConnection.connect(mysql.ConnectionSettings(
        host: global.coreIP,
        port: 3306,
        user: 'app',
        password: 'wUYzH7mi',
        db: 'Core'));

    var result = await conn.query('select brightness from settings');

    for (var row in result){
      _currentSliderValue = row[0];
    }

    await conn.close();

  }

  @override
  void initState(){
    super.initState();
    IPcontroller.text = global.coreIP;
    _sync();
  }

  final PreferencesStorage storage = PreferencesStorage();

  String _dropDownThemeValue = global.themeNames[global.themeId];

  final IPcontroller = TextEditingController();

  double _currentSliderValue = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: _backButton()
      ),
      body: Container(
          child: Column(
              children: [
                Container(
                  child: _themeDropDown()
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.only(top: 20, bottom: 15),
                  alignment: Alignment.topCenter,
                  child: _brightnessSlider()
                ),
                Divider(),
                Container(
                  alignment: Alignment.topCenter,
                  child: _ipTextField()
                )
              ]
          )
      ),
    );

  }

  Widget _backButton() {

    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: (){
        storage.writePreferences(1, global.coreIP);
        storage.writePreferences(0, global.themeId);
        Navigator.pop(context);
      },
    );

  }

  Widget _themeDropDown() {

    return ListTile(
      title: Text("Theme", style: TextStyle(fontSize: 20)),
      trailing: DropdownButton <String>(
        value: _dropDownThemeValue,
        style: TextStyle(fontSize: 20),
        items: <String>['Rainbow', 'Purple', 'Black']
            .map<DropdownMenuItem<String>>((String value){
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String newValue){
          setState(() {
            global.themeId = global.themeNames.indexWhere((element) => element == newValue);
            _dropDownThemeValue = global.themeNames[global.themeId];
          });
        },
      ),
    );

  }

  Widget _brightnessSlider() {

    return  Column(
        children: [
          Text('Brightness', style: TextStyle(fontSize: 20)),
          Slider(
            value: _currentSliderValue,
            min: 10,
            max: 100,
            divisions: 100,
            onChanged: (double value) {
              updateSettingsDb(value.toInt());
              setState(() {
                _currentSliderValue = value;
              });
            },
          )
        ]
    );

  }

  Widget _ipTextField(){

    return Column(
      children: [
        Text("CEDS-Core IP:", style: TextStyle(fontSize: 20)),
        Container(
          width: 170,
          child: TextField(
            keyboardType: TextInputType.number,
            controller: IPcontroller,
            textAlign: TextAlign.center,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white, fontSize: 20),
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              hintText: IPcontroller.text != '' ? IPcontroller.text : global.coreIP,
            ),
            onChanged: (value) {
              global.coreIP = value;
            },
          )
        )
      ],
    );

  }

}


class PreferencesStorage {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFileTheme async {
    final path = await _localPath;
    //print('$path');
    return File('$path/theme.txt');
  }

  Future<File> get _localFileIP async {
    final path = await _localPath;
    //print('$path');
    return File('$path/IP.txt');
  }

  Future<String> readPreferences(int selector) async {

    var file;

    if(selector == 0){
      file = await _localFileTheme;
    }
    else if(selector == 1){
      file = await _localFileIP;
    }

    // Read the file
    //print('Reading as string: ');
    String contents = await file.readAsString();
    //print('$contents');

    return contents;
  }

  Future<File> writePreferences(int selector, final value) async {

    var file;

    if(selector == 0){
      file = await _localFileTheme;
    }
    else if(selector == 1){
      file = await _localFileIP;
    }

    // Write the file
    return file.writeAsString('$value');
  }

}



