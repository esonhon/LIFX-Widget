LiFX-Widget
===========

Manage your (awesome) [LiFX](http://www.lifx.co "LiFX's website") bulbs. Right from notification center.
Change their colours, turn them off an on, without having to open the main app.

Thanks Apple for opening iOS 8 !

Screenshots
-----------
![Widget screenshot](/screenshots/Widget.png?raw=true "Widget screenshot")

Widget
-----------
Simply press your light name, then pick a colour. Toogle the selected light using the bottom switch.

A greyed out light name means that it couldn't be found on the network.
If the widget can't detect your light, make sure you're on the same wireless network and the light bulb isn't electrically switched off.

Companion app
-----------
The companion app is used to configure the widget itself. It allows you to :
- Pick your favourite lights to be displayed in the widget (*Since you might own 40 bulbs, display all of them in the notification center wouldn't be the best solution*),
- Nickname a favourite light (*The light won't be renamed, only the name displayed in the widget will be changed*),
- Configure the colours to be displayed in the widget.

Installation
-----------
As soon as iOS 8 will be officialy out, I'll distribue it through the App Store.

However, for now, you'll have to clone the repo, install the dependency using [CocoaPods](http://cocoapods.org, "CocoaPods website") and build it (using Xcode 6) yourself.
```bash
$ gem install cocoapods # if it isn't already installed
$ git clone https://github.com/DCMaxxx/LiFX-Widget.git
$ cd LiFX-Widget/project
$ pod install
$ open "LiFX Widget.xcworkspace"
```

To enable data communication (displayed lights / colours) between the companion and the widget, you'll need to setup an App group. To do so, see [App extension programming guide](https://developer.apple.com/library/prerelease/ios/documentation/General/Conceptual/ExtensibilityPG/ExtensibilityPG.pdf, "App extension programming guide"), page 22. Name it `group.LiFXWidgetSharingDefaults`.
**I'm having trouble with it though. See issues below**.

Then, build and run the `LiFX Widget Companion` scheme, followed by the `LiFX Widget` one.

To-Do
-----------
Here's a completly unordered todo list of the upcoming features (or at least things I'd like to do). PR welcome ❤️.
- Better UI in the companion app,
- Update the widget view in the background using the `NCWidgetProviding` protocol,
- Hide the widget on cellular data (*I'm pretty sure I read somewhere I can do this*),

Known issues & other stuff
-----------
You'll see a few `FIXME` here and there in the code. These are working stuff that I don't like. I won't be working on it for a couple of weeks, and I've been asked to put the repo on GitHub, so here it is.

The most important issue is that for now, **sharing data between the companion app and the widget doesn't work**. ie: the configuration of displayed lights and colours.

**Short story:** You'll need to hardcode a list of colours and lights in `SettingsPersistanceManager.swift`, `initHardCodedLights()` and `initHardCodedColours()`. The modifications made in the companion app will be reset upon launch.

**Long story:** For some reason, when I archive my custom classes in the shared `NSUserDefaults` from the companion app, I can't unarchive it from the widget (and vice-versa), `NSKeyedUnarchiver.unarchiveObjectWithData()` crashes - the `NSData` is there, the keyed unarchiver just doesn't seem to understand it. Archiving and unarchiving in the same app works though... I don't know if I do it wrong, or if it's a beta-related issue, and I didn't have enough time to look into it yet.
`initHardCoded{Lights,Colours}()` archives your custom lights and colours when you run either app, so the later calls to `NSKeyUnarchiver.unarchiveObjectWithData()` will be able to unarchive the data - since it has been archived on app launch.

Also, debugging extension is a freaking pain in the ass. Sometimes, changes won't be applied when you build and run it. Sometimes, the widget's height is 0. Sometimes, the widget is removed and you'll need to add it again.
When I get these issues I remove the app from my device or reset simulators, run the companion scheme then the widget scheme. It *usually* works.

Have fun 😄 !
