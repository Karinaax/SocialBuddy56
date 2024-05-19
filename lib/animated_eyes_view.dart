import 'dart:async';
//import 'package:AnimationBuddy/main.dart';

import 'package:buddy_animation/flic_button_connection_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

import 'package:flic_button/flic_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';


class AnimatedEyesView extends StatefulWidget {
  final Key? key;

  AnimatedEyesView({this.key}) : super(key: key);


  @override
  State<AnimatedEyesView> createState() => _AnimatedEyesViewState();


}

class MyParentWidget extends StatelessWidget {
  final GlobalKey<_AnimatedEyesViewState> animatedEyesViewKey = GlobalKey<_AnimatedEyesViewState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedEyesView(key: animatedEyesViewKey),
        FlicButtonPage(
          onButtonPressed: () {
            // Roep de triggerAnimation methode aan
            animatedEyesViewKey.currentState?.triggerAnimation();
          },
        ),
      ],
    );
  }
}


class _AnimatedEyesViewState extends State<AnimatedEyesView> {
  Artboard? _riveArtBoard;
  StateMachineController? _controller;
  bool leftHandUpValueSwitch = false;
  bool rightHandUpValueSwitch = false;
  bool brushTeethElectricSwitch = false;
  bool brushTeethSwitch = false;
  bool openEyeWhenSleepingSwitch = false;
  bool sleepSwitch = false;
  bool noBlinkSwitch = false;
  bool readSwitch = false;
  bool eatSwitch = false;
  bool drinkSwitch = false;
  bool rubEyesSwitch = false;
  bool eyeOpenLeftSwitch = false;
  bool eyeOpenRightSwitch = false;
  bool pupilFollowSwitch = false;
  bool lookExitSwitch = false;
  SMIInput<bool>? _rightHandUpValue;
  SMIInput<bool>? _leftHandUpValue;
  SMIInput<bool>? _brushTeethElectric;
  SMIInput<bool>? _brushTeeth;
  SMIInput<bool>? _openEyeWhenSleeping;
  SMITrigger? _wave;
  SMIInput<bool>? _sleep;
  SMIInput<bool>? _noBlink;
  SMITrigger? _medication;
  SMIInput<bool>? _eat;
  SMIInput<bool>? _read;
  SMIInput<bool>? _drink;
  SMITrigger? _knock;
  SMIInput<bool>? _rubEyes;
  SMITrigger? _wakeUp;
  SMITrigger? _idle;
  SMITrigger? _blink;
  SMITrigger? _blinkLeft;
  SMITrigger? _blinkRight;
  SMIInput<bool>? _eyeOpenLeft;
  SMIInput<bool>? _eyeOpenRight;
  SMIInput<bool>? _pupilFollow;
  SMIInput<bool>? _lookExit;
  static const _riveUpdateFrameRate = 30;

  Duration get _riveUpdateInterval {
    int millisecondInterval = (1000 / _riveUpdateFrameRate).round();
    return Duration(milliseconds: millisecondInterval);
  }

  Timer? _riveFrameUpdateTimer;
  RiveFile? _file;

  bool get _isInitialized => _riveArtBoard != null;

  @override
  void initState() {
    _initArtBoard();
    super.initState();
  }



  @override
  void onButtonClicked(Flic2ButtonClick buttonClick)  {
    if (_controller != null && _medication != null) {
      _medication!.fire();
      print("Medication animation triggered.");
    } else {
      print("Controller or Medication trigger is not available.");
    }
  }

  void triggerAnimation() {
    if (_controller != null) {
      final SMITrigger? trigger = _controller!.findInput('Medication') as SMITrigger?;
      trigger?.fire();
    }
  }

  @override
  void dispose() {
    _riveFrameUpdateTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  // Future<void> _initArtBoard() async {
  Future<void> _initArtBoard({bool isFromUpdateState = false, double? rightHandValue, double? leftHandValue}) async {
    if (!isFromUpdateState) {
      assert(!_isInitialized, 'ArtBoard already initialized');
    } else {
      isInitialising = true;
    }
    if (_riveArtBoard == null) {
      // if (_riveArtBoard == null || !isFromUpdateState) {
      final riveByteData = await rootBundle.load('assets/rive/buddy_final.riv');
      RiveFile riveFile = RiveFile.import(riveByteData);
      _riveArtBoard = riveFile.mainArtboard;
    }

    // _riveArtBoard!.value.antialiasing = false;
    _controller = StateMachineController.fromArtboard(_riveArtBoard!, 'buddy-V2') as StateMachineController;
    _controller!.isActive = true;
    _controller!.inputs.forEach((element) {
      debugPrint("${element.type} ${element.name}");
    });
    _riveArtBoard!.addController(_controller!);
    _leftHandUpValue = _controller!.findSMI('LeftHand-Up');
    _rightHandUpValue = _controller!.findInput('RightHand-Up');
    _brushTeethElectric = _controller!.findInput('Brush-Teeth-Electric');
    _brushTeeth = _controller!.findInput('Brush-Teeth');
    _openEyeWhenSleeping = _controller!.findInput('Open-Eye-When-Sleeping');
    _wave = _controller!.findInput<bool>('Wave') as SMITrigger;
    _sleep = _controller!.findInput('Sleep');
    _noBlink = _controller!.findInput('NoBlink');
    _medication = _controller!.findInput<bool>('Medication') as SMITrigger;
    _eat = _controller!.findInput('Eat');
    _read = _controller!.findInput('Read');
    _drink = _controller!.findInput('Drink');
    _knock = _controller!.findInput<bool>('Knock') as SMITrigger;
    _rubEyes = _controller!.findInput('RubEyes');
    _wakeUp = _controller!.findInput<bool>('WakeUp') as SMITrigger;
    _idle = _controller!.findInput<bool>('Idle') as SMITrigger;
    _blink = _controller!.findInput<bool>('Blink') as SMITrigger;
    _blinkLeft = _controller!.findInput<bool>('BlinkLeft') as SMITrigger;
    _blinkRight = _controller!.findInput<bool>('BlinkRight') as SMITrigger;
    _eyeOpenLeft = _controller!.findInput('EyeOpenLeft');
    _eyeOpenRight = _controller!.findInput('EyeOpenRight');
    _pupilFollow = _controller!.findInput('PupilFollow');
    _lookExit = _controller!.findInput('LookExit');
    _drink!.change(false);
    // _sleep!.value = false;
    _idle!.change(true);

    _controller!.addEventListener((p0) {
      debugPrint("p0 $p0");
    });

    _controller!.addRuntimeEventListener((p0) {
      debugPrint("p0 run $p0");
    });

    if (mounted) {
      setState(() {});
    }
  }

  bool isInitialising = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight, //Amazon Fire device when camera down
      DeviceOrientation.landscapeLeft, //Amazon Fire device when camera Up
    ]);



    return Container(
      color: Colors.white,
      child: _riveArtBoard == null
          ? const Center(
        child: CupertinoActivityIndicator(),
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.5,
              child: Rive(
                artboard: _riveArtBoard!,
                fit: BoxFit.contain,
                useArtboardSize: true,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                CustomSwitch(
                    value: leftHandUpValueSwitch,
                    text: "Left hand",
                    onChanged: (bool value) {
                      setState(() {
                        leftHandUpValueSwitch = value;
                      });
                      _leftHandUpValue!.change(value);
                    }),
                CustomSwitch(
                    value: rightHandUpValueSwitch,
                    text: "Right hand",
                    onChanged: (bool value) {
                      setState(() {
                        rightHandUpValueSwitch = value;
                      });
                      _rightHandUpValue!.change(value);
                    }),
                CustomSwitch(
                    value: brushTeethElectricSwitch,
                    text: "Brush teeth electric",
                    onChanged: (bool value) {
                      setState(() {
                        brushTeethElectricSwitch = value;
                      });
                      _brushTeethElectric!.change(value);
                    }),
                CustomSwitch(
                    value: brushTeethSwitch,
                    text: "Brush teeth",
                    onChanged: (bool value) {
                      setState(() {
                        brushTeethSwitch = value;
                      });
                      _brushTeeth!.change(value);
                    }),
                CustomSwitch(
                    value: openEyeWhenSleepingSwitch,
                    text: "Open eye when sleeping",
                    onChanged: (bool value) {
                      setState(() {
                        openEyeWhenSleepingSwitch = value;
                      });
                      _openEyeWhenSleeping!.change(value);
                    }),
                GetButton(
                    text: "Wave",
                    onPressed: () {
                      _wave!.fire();
                    }),
                CustomSwitch(
                    value: sleepSwitch,
                    text: "Sleep",
                    onChanged: (bool value) {
                      setState(() {
                        sleepSwitch = value;
                      });
                      _sleep!.change(value);
                    }),
                CustomSwitch(
                    value: noBlinkSwitch,
                    text: "No Blink",
                    onChanged: (bool value) {
                      setState(() {
                        noBlinkSwitch = value;
                      });
                      _noBlink!.change(value);
                    }),
                GetButton(
                    text: "Medication",
                    onPressed: () {
                      _medication!.fire();
                      print("medicatie");
                    }),
                CustomSwitch(
                    value: eatSwitch,
                    text: "Eat",
                    onChanged: (bool value) {
                      setState(() {
                        eatSwitch = value;
                      });
                      _eat!.change(value);
                    }),
                CustomSwitch(
                    value: readSwitch,
                    text: "Read",
                    onChanged: (bool value) {
                      setState(() {
                        readSwitch = value;
                      });
                      _read!.change(value);
                    }),
                CustomSwitch(
                    value: drinkSwitch,
                    text: "Drink",
                    onChanged: (bool value) {
                      setState(() {
                        drinkSwitch = value;
                      });
                      _drink!.change(value);
                    }),
                GetButton(
                    text: "Knock",
                    onPressed: () {
                      _knock!.fire();
                    }),
                CustomSwitch(
                    value: rubEyesSwitch,
                    text: "Rub eyes",
                    onChanged: (bool value) {
                      setState(() {
                        rubEyesSwitch = value;
                      });
                      _rubEyes!.change(value);
                    }),
                GetButton(
                    text: "Wake up",
                    onPressed: () {
                      _wakeUp!.fire();
                    }),
                GetButton(
                    text: "Idle",
                    onPressed: () {
                      _idle!.fire();
                    }),
                GetButton(
                    text: "Blink",
                    onPressed: () {
                      _blink!.fire();
                    }),
                GetButton(
                    text: "Blink left",
                    onPressed: () {
                      _blinkLeft!.fire();
                    }),
                GetButton(
                    text: "Blink right",
                    onPressed: () {
                      _blinkRight!.fire();
                    }),
                CustomSwitch(
                    value: eyeOpenLeftSwitch,
                    text: "Eye open left",
                    onChanged: (bool value) {
                      setState(() {
                        eyeOpenLeftSwitch = value;
                      });
                      _eyeOpenLeft!.change(value);
                    }),
                CustomSwitch(
                    value: eyeOpenRightSwitch,
                    text: "Eye open right",
                    onChanged: (bool value) {
                      setState(() {
                        eyeOpenRightSwitch = value;
                      });
                      _eyeOpenRight!.change(value);
                    }),
                CustomSwitch(
                    value: pupilFollowSwitch,
                    text: "Pupil follow",
                    onChanged: (bool value) {
                      setState(() {
                        pupilFollowSwitch = value;
                      });
                      _pupilFollow!.change(value);
                    }),
                CustomSwitch(
                    value: lookExitSwitch,
                    text: "Look exit",
                    onChanged: (bool value) {
                      setState(() {
                        lookExitSwitch = value;
                      });
                      _lookExit!.change(value);
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class GetButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;

  const GetButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: CupertinoColors.black,
          elevation: 0.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          minimumSize: const Size(75, 35),
          padding: const EdgeInsets.all(8.0),
        ),
        onPressed: onPressed ?? () {},
        child: Text(text ?? "", style: const TextStyle(color: Colors.white)));
  }
}

class CustomSwitch extends StatefulWidget {
  final bool value;
  final Color? enableColor;
  final String text;
  final Color? disableColor;
  final double? width;
  final double? height;
  final double? switchHeight;
  final double? switchWidth;
  final ValueChanged<bool> onChanged;

  const CustomSwitch(
      {super.key,
        required this.value,
        this.enableColor,
        this.disableColor,
        this.width,
        this.height,
        this.switchHeight,
        this.switchWidth,
        required this.onChanged,
        required this.text});

  @override
  CustomSwitchState createState() => CustomSwitchState();
}

class CustomSwitchState extends State<CustomSwitch> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 60));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: const TextStyle(fontSize: 16, color: Colors.black, decoration: TextDecoration.none),
        ),
        const SizedBox(width: 10),
        AnimatedBuilder(
          animation: _animationController ?? AnimationController(vsync: this),
          builder: (context, child) {
            return GestureDetector(
              onTap: () {
                if (_animationController!.isCompleted) {
                  _animationController!.reverse();
                } else {
                  _animationController!.forward();
                }
                widget.value == false ? widget.onChanged(true) : widget.onChanged(false);
              },
              child: Container(
                width: widget.width ?? 5,
                height: widget.height ?? 29.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                  color: !widget.value ? Colors.grey : Colors.green,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.0, bottom: 2.0, right: 2.0, left: 2.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    alignment: widget.value ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      width: widget.switchWidth ?? 20.0,
                      height: widget.switchHeight ?? 20.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 4, spreadRadius: 1, blurStyle: BlurStyle.normal)]),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );


  }


}