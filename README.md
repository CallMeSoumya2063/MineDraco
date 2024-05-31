# draco-injector-script
A user friendly bash script for Termux that automates the whole process of patching using Draco injector (a repo by mcbegamerxx954, available [here](https://github.com/mcbegamerxx954/draco-injector))

Made in 1 day with help from chatgpt  (for overall queries because I don't know bash very well) and [devendrn](https://github.com/devendrn) (helped fix an issue, credited him in code)

# How to Use
1. Download [latest script from releases](https://github.com/CallMeSoumya2063/draco-injector-script/releases/latest)
2. Put Minecraft apk (make sure it has 'Minecraft' in its name in any way) in Download folder in internal storage
> *Minecraft from Play Store requires an extra step: Antisplit using [Apktool M](https://maximoff.su/apktool/?lang=en) and then move produced file to Download folder in internal storage*
3. Download and install [termux from GitHub](https://github.com/termux/termux-app/releases/latest)
4. Run this command: (For first time using the script)
```
curl -o injector.sh https://raw.githubusercontent.com/CallMeSoumya2063/draco-injector-script/main/injector.sh && bash injector.sh
```
5. Read instructions on screen and follow.

> [!NOTE]
> Make sure you are connected to the internet while running the script. For everytime after the first run, just `bash injector.sh` is enough. When script is updated, you need to update the script. To run updated script, run the command from step 5. After that, `bash injector.sh` is enough.

# More important info on App name and Package name:
- **App Name**: This is what you see on your phone’s screen, like `Minecraft`. While patching, you can input whatever name you want, like `Minecraft Patched` or `Minecraft (Patch)`.
- **Package Name**: This is a unique ID used by Android, like `com.mojang.minecraftpe` for Minecraft. While patching, you can input anything like `com.mojang.minecraftpe.patched` or `com.moyang.bugrock.patch`. **However, keep the structure of the original name (com.mojang.minecraftpe) or game may crash.**

# 32bit and 64bit support
This script by default uses auto detected architecture of your device. But you can patch apk for 32bit and 64bit both on any Android device. While patching an APK other than what your device supports, make sure not to use auto-detected architecture and type `arm` (for 32bit) or `aarch64` (for 64bit) before pressing ENTER, during the 30 second time the script lets you manually change architecture.





***Please contribute and post your issues and/or suggestions for further improvements in the project.***

Again, special thanks to [devendrn](https://github.com/devendrn) and [mcbegamerxx954](https://github.com/mcbegamerxx954) for their help during the development, and `@sparklight77` (discord) for testing the script several times before publish.
