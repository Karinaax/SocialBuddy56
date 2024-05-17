
# SocialBuddy Project56 - buddy externe camera
## Getting Started

In dit gedeelte van het project werken we aan de implementatie van een externe camera met Social Buddy. Bij het opstarten van de applicatie wordt de camera geactiveerd en kan de interactieve ervaring met de social buddy animatie beginnen. Ook kan er wanneer nodig de camera gebruikt worden voor het videobellen. 



## Used dependencies
- cupertino_icons: ^1.0.6
- camera: ^0.10.0+4
- path_provider: ^2.0.11
- image_picker: ^0.8.5+3
- permission_handler: ^11.2.0
- video_player: ^2.3.0

## Configuratie van Android in **AndroidManifest.xml**
- uses-permission android:name="android.permission.CAMERA"
- uses-permission android:name="android.permission.RECORD_AUDIO"
- uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
- uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"

## Used packages
- package:flutter/material.dart
- package:camera/camera.dart


