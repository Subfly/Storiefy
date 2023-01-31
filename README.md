# story_way

A new way of creating Instagram like stories in Flutter.

## Getting Started

Install Flutter if not available in your computer from:
- [Official Flutter Website](https://docs.flutter.dev/get-started/install)

Install Android Studio if available in your computer form:
- [Official Android Studio Website](https://developer.android.com/studio?gclid=Cj0KCQiA8t2eBhDeARIsAAVEga3YBXLFbK_rctgmI8ZyoWuHS9iifuVni2fSbmYtVBA5e5KQs3ioBPEaAslgEALw_wcB&gclsrc=aw.ds)

Install XCode from AppStore if you are using macOS

Install VSCode from:
- [Official VSCode Website](https://code.visualstudio.com/)

Install these required extensions for VSCode in order to be able to run Flutter:
- Dart
- Flutter

Then just run the app. 

!!! Important:
- If you are using iOS emulator, as the video_player package relies on AVMediaPlayer, the app will
- crash due to unavailability of the player. Try to run on a real device.

# StoryWay

StoryWay is the new way of implementing the Instagram like stories functionality
in Flutter. Most of the other implementations rely on navigating through a 
list of stories of users. In my opinion, it is also possible to apply same effect
without navigating, however using pagers. PageView is a very powerful Widget that
enabled the way of implementing this functionality.

Not only that, the implementation has been made via respecting the SOLID principles.

- Clean Architecture with Data, Domain and Presentation layers
- Dependency Injection on Preferences (Hive, Shared Preferences) and Database (Hive, Sqflite)
- MVVM-like Architecture with Cubit State Management
- Very simple Event Driven Architecture on story implementation
- Ready-to-use JSON dataset with service layer that simulates API calls
- Sliver Tab Bar implementation with GridView and ListView
- Powerful, fast and good looking animations
  
## You want sneak peeks? There are sneak peeks!