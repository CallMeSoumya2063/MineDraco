# draco-injector-script
A user friendly bash script for Termux that automates the whole process of patching using Draco injector (a repo by mcbegamerxx954, available [here](https://github.com/mcbegamerxx954/draco-injector))

Made in 1 day with help from chatgpt  (for overall queries because I don't know bash very well) and [devendrn](https://github.com/devendrn) (helped fix an issue, credited him in code)

# How to Use
1. Download latest script from releases
2. Put Minecraft apk (make sure it has 'Minecraft' in its name in any way) in Download folder in internal storage
(Minecraft from Play Store requires an extra step: Antisplit using [Apktool M](https://maximoff.su/apktool/?lang=en) and move produced file to Download in internal storage)
3. Download and install [termux from GitHub](https://github.com/termux/termux-app/releases/latest)
4. Give storage permission to manually from app settings. (For first time termux users)
5. Run this command: (For first time using the script)
```
cp /storage/emulated/0/Download/injector.sh ~ && bash injector.sh
```
6. Read instructions on screen and follow.

For everytime after the first run, just `bash injector.sh` is enough. When script is updated, you need to update the script. To update script, download updated script from releases and run the command from step 5. After that, `bash injector.sh` is enough.

# Note:
You can patch apk for 32bit and 64bit both on any Android device. Just make sure not to use auto-detected architecture and type `arm` (for 32bit) or `aarch64` (for 64bit) before pressing ENTER, during the 30 second time the script lets you manually change architecture.


***Please contribute and post your issues and/or suggestions for further improvements in the project.***

Again, special thanks to [devendrn](https://github.com/devendrn) and [mcbegamerxx954](https://github.com/mcbegamerxx954) for their help during the development, and `@sparklight77` (discord) for testing the script several times before publish.
