# draco-injector-script
A user friendly bash script for Termux that automates the whole process of patching using Draco injector (a repo by mcbegamerxx954, available [here](https://github.com/mcbegamerxx954/draco-injector))

Made in 1 day with help from chatgpt  (for overall queries because I don't know bash very well) and [devendrn](https://github.com/devendrn) (helped fix an issue, credited him in code)

> *Script now updated for v0.1.5 of Draco injector!*
> **Bonus update:**
> - Cleaner, faster & fancier!
> - No more "yes" or "no" questions!
> - x86_64 support!

# How to Use
1. Put Minecraft apk (make sure it has 'Minecraft' in its name in any way) in Download folder in internal storage
> *Minecraft from Play Store requires an extra step: Antisplit using [Apktool M](https://maximoff.su/apktool/?lang=en) and then move produced file to Download folder in internal storage*
2. Download and install [termux from GitHub](https://github.com/termux/termux-app/releases/latest)
3. Paste this command in Termux and press ENTER to run the script: (For first time using the script)
```
curl https://raw.githubusercontent.com/CallMeSoumya2063/draco-injector-script/main/injector.sh > injector.sh && bash injector.sh
```
4. Read instructions on screen and follow (pressing ENTER accepts your inputs).

> [!IMPORTANT]
> Patched APK made by this script only loads shader from Global Resources, and the APK may be buggy or unstable on some devices. Please report APK issues [here](https://github.com/mcbegamerxx954/draco-injector/issues) and mention you used my script for patching.

> [!NOTE]
> Make sure you are connected to the internet while running the script. For everytime after the first run, just `bash injector.sh` is enough. When script is updated, you need to update the script. To run updated script, run the command from step 3. After that, `bash injector.sh` is enough.

# More important info on App name and Package name:
- **App Name**: This is what you see on your phone’s screen, like `Minecraft`. While patching, you can input whatever name you want, like `Minecraft Patched` or `Minecraft (Patch)`.
- **Package Name**: This is a unique ID used by Android, like `com.mojang.minecraftpe` for Minecraft. While patching, you can input anything like `com.mojang.minecraftpe.patched` or `com.moyang.bugrock.patch`. **However, keep the structure of the original name (com.mojang.minecraftpe) or game may crash.**

# All architectures supported
This script uses auto detected architecture of your device to download injector files from GitHub. But you can patch APK for all architectures on any Android device, as any injector can patch Minecraft for any architecture.




***Please contribute and post your issues and/or suggestions for further improvements in the project.***

Again, special thanks to [devendrn](https://github.com/devendrn) and [mcbegamerxx954](https://github.com/mcbegamerxx954) for their help during the development, and `@sparklight77` (discord) for testing the script several times before publish.
