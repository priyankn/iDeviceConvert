# iDeviceConvert
 Patch an iPad-only app which doesn't run on an iPhone or vice-versa.

## Help

```
Syntax: ./iDeviceConvert.sh [/path/to/IPA/file] 

options:
h     Print this help
```

## Example

```
$ ./iDeviceConvert.sh Visitors.ipa 
[+] Extracting..
[2]
[+] Detected IPad, Insert for iPhone
[+] Detected UISupportedDevices, removing this key
[+] Done. Patched as updated_Visitors.ipa
```

## How it works

We change the `UIDeviceFamily` (Number or Array - iOS) which specifies the underlying hardware type on which this app is designed to run. 
  1 - (Default) The app runs on iPhone and iPod touch devices
  2 - The app runs on iPad devices

 Also, if the app declares `UISupportedDevices`, we will remove it.
 
 
## Known Issues

If the IPA name contains spaces, bash might complain ;) because I am simply passing in cmd line arg $1. This might be fixed in a future release. Workaround is to rename it to a single string.
 
 ## Development  
 
Feel free to submit PRs and/or your test failures
