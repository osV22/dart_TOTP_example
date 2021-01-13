import 'package:flutter/material.dart';
import 'package:otp/otp.dart';
import 'package:base32/base32.dart';

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
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'TOTP Auth Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // To get KEY for the authenticator
  // This output is what you put in your authenticator app like Google's, etc...

  final String _authKeySecret = base32.encodeString('hotDogOrNotHotdog');
  String _currentCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'TOTP Auth',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 10),
            Text(
              'base32 Auth Secret Key:\n ${_authKeySecret.replaceAll('=', '')}',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 50),
            Text(
              'Current code:\n${_currentCode != null ? _currentCode : 'Click + to update state'} ',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 50),
            Text(
              'Click + to see the latest code generated ',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          int currentTime = DateTime.now().millisecondsSinceEpoch;
          // String to see trailing 0
          var timedCode = OTP.generateTOTPCodeString(
            _authKeySecret,
            currentTime,
            length: 6,
            interval: 30,
            algorithm: Algorithm
                .SHA256, // PLEASE change this from default/ suggested SHA1 which is a lot less secure
            isGoogle: true,
          );
          setState(() {
            _currentCode = timedCode;
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This
    );
  }
}
