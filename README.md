# iKeyHelper
--
iKeyHelper is a script for Windows to get AES keys from Apple's iOS Firmware.

iKeyHelper is scripted in Batch. Its features include: formatting for TheiPhoneWiki, decryption of files, use of the Firmware Links API, baseband detection, preparation for bundle making, and much more!

<img src="http://www.callumjones.me/assets/images/iKeyHelper.png" alt="iKeyHelper">

## Preparation

Open iKeyHelper and allow it to unpack the tools, then when it has gone to the "IPSW" screen, run the `resources\boot-args.bat` - this will make injectpois0n halt after the payload has been run, rather than rebooting.

## Resources

iKeyHelper uses the following:

* **XPwn** by planetbeing
* **greenpois0n** by chronic-dev
* **irecovery** by westbaer
* **7zip** by Igor Pavlov
* **SSR** by Jonas Reinhardt
* **Binmay** by sloaring
* various parts of **Cygwin**
* ideviceinfo and dll's from **libimobiledevice**

If you want to use iKeyHelper, you must first collect these parts - as a general guidance, you can find the required .exe's in `resources/tools.txt`. When you have them, place them in `resources/tools/` and run the iKeyHelper.bat. It will then run from the files.

Also, you need iTunes, libusb (and device filters installed for each mode) for iKeyHelper to function properly.

## License

**iKeyHelper** is licensed under the GNU GPL v3. See the LICENSE file for more information.

## Credits

iKeyHelper wouldn't have been possible without the following people

* **iNeal** - for baseband detection and other key parts
* **iH8sn0w** - for the non-existent iKeys which prompted the starting of this project
* **Atarii** - for autoirecovery (a tool you never saw) - which was once at the core of iKeyHelper
* **members of the case**