import 'dart:io';

import 'package:buddy_animation/animated_eyes_view.dart';
import 'package:flutter/material.dart';
import 'package:flic_button/flic_button.dart';
import 'package:permission_handler/permission_handler.dart';

class FlicButtonPage extends StatefulWidget {
  final VoidCallback onButtonPressed;
  const FlicButtonPage({Key? key, required this.onButtonPressed}) : super(key: key);

  @override
  _FlicButtonPageState createState() => _FlicButtonPageState();
}

class _FlicButtonPageState extends State<FlicButtonPage> with Flic2Listener {
  bool _isScanning = false;
  final Map<String, Flic2Button> _buttonsFound = {};

  Flic2ButtonClick? _lastClick;
  FlicButtonPlugin? flicButtonManager;
  bool _isButtonConnected = false;
  void Function()? onFlicButtonPressed;
  // AnimatedEyesView? animatedEyesView; // Add this line

  @override
  void initState() {
    super.initState();
    _startStopFlic2();
    onFlicButtonPressed = () {
      print("Flic button pressed!");

    };

  }

  void _startStopScanningForFlic2() async {
    final bluetoothPermissionStatus = await Permission.bluetooth.request();
    final locationPermissionStatus = await Permission.location.request();

    if (bluetoothPermissionStatus.isGranted && locationPermissionStatus.isGranted) {
      if (!_isScanning) {
        flicButtonManager?.scanForFlic2();
      } else {
        flicButtonManager?.cancelScanForFlic2();
      }
      setState(() {
        _isScanning = !_isScanning;
      });
    } else {
      if (bluetoothPermissionStatus.isGranted) {
        print('Bluetooth permission granted');
      } else if (locationPermissionStatus.isGranted) {
        print('Location permission granted');
      } else {
        print('Bluetooth and Location permissions are required for scanning.');
        print('testtt');
      }
    }
  }

  void _startStopFlic2() {
    if (null == flicButtonManager) {
      setState(() {
        flicButtonManager = FlicButtonPlugin(flic2listener: this);
      });
    } else {
      flicButtonManager?.disposeFlic2().then((value) => setState(() {
        flicButtonManager = null;
      }));
    }
  }

  void _getButtons() {
    flicButtonManager?.getFlic2Buttons().then((buttons) {
      buttons.forEach((button) {
        _addButtonAndListen(button);
      });
    });
  }

  void _addButtonAndListen(Flic2Button button) {
    setState(() {
      _buttonsFound[button.uuid] = button;
      flicButtonManager?.listenToFlic2Button(button.uuid);
    });
  }

  void _navigateToAnimationPage() {
    // Navigeer naar de animatiepagina en geef de gevonden knoppen door
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => AnimatedEyesView(),
      ),
    );
  }

  @override
  void onButtonConnected() {
    super.onButtonConnected();

    //   super.onButtonConnected();

    setState(() {
      print('button connected');
      _isScanning = false;
      _isButtonConnected = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Flic Button is connected!'),
        duration: Duration(seconds: 2),
      ),
    );
    // Wacht 2 seconden en navigeer dan naar de animatiepagina
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        _navigateToAnimationPage();
        print("naar AnimatedEyesView");
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect Flic Button'),
      ),
      body: Center(
        child: _isButtonConnected
            ? Text('Flic Button is connected!')
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Waiting for Flic Button connection...'),
            ElevatedButton(
              onPressed: () {
                if (!_isScanning) {
                  _startStopScanningForFlic2();
                  print("bezig");
                } else {
                  // Handle the case when the app is currently scanning
                  print("scannen man");
                }
              },
              child: Text(_isScanning ? 'Scanning...' : 'Connect Flic Button'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onButtonClicked(Flic2ButtonClick buttonClick) {

    print('button ${buttonClick.button.uuid} clicked');
    setState(() {
      _lastClick = buttonClick;
    });

    if (onFlicButtonPressed != null) {
      onFlicButtonPressed!();
    }

    widget.onButtonPressed();



  }


  void _showOnScreenMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }


  @override
  void onButtonUpOrDown(Flic2ButtonUpOrDown button) {
    super.onButtonUpOrDown(button);
    print('button ${button.button.uuid} ${button.isDown ? 'down' : 'up'}');
  }

  @override
  void onButtonDiscovered(String buttonAddress) {
    super.onButtonDiscovered(buttonAddress);
    print('button @$buttonAddress discovered');
    flicButtonManager?.getFlic2ButtonByAddress(buttonAddress).then((button) {
      if (button != null) {
        print('button found with address $buttonAddress resolved to actual button data ${button.uuid}');
        _addButtonAndListen(button);
      }
    });
  }

  @override
  void onButtonFound(Flic2Button button) {
    super.onButtonFound(button);
    print('button ${button.uuid} found');
    _addButtonAndListen(button);
  }

  @override
  void onFlic2Error(String error) {
    super.onFlic2Error(error);
    print('ERROR: $error');
  }

  @override
  void onPairedButtonDiscovered(Flic2Button button) {
    super.onPairedButtonDiscovered(button);
    print('paired button ${button.uuid} discovered');
    _addButtonAndListen(button);
  }

  @override
  void onScanCompleted() {
    super.onScanCompleted();
    setState(() {
      _isScanning = false;
    });
  }

  @override
  void onScanStarted() {
    super.onScanStarted();
    setState(() {
      _isScanning = true;
    });
  }


}


