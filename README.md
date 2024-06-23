# dell-bios-recovery
How to extract Dell BIOS from exe file and write into the EEPROM.

First, this post is only for educational purposes. We're not responsible for any loss or damages. Use at your own risk. 

## Prerequisites
Download Hex Workshop from BreakPoint Software website (http://www.bpsoft.com/downloads/) and install.

## Download BIOS exe file
At Dell Support page (https://www.dell.com/support/home/pt-br) search by device's service tag. Mine Vostro 5470 service tag is 5Y5Q442. Then at Drivers tab download the latest driver available.

## Extract the BIOS binary file
There are some tutorial online, they usually uses a Batch or a Python script to extract the BIOS and ME binary files. See #References bellow. I read the scripts, tested some options with [5470A12.exe] and created my own way to extract them.

### BIOS binary file
First we extract the [BIOS.cap] and the [BIOS_BIOS.bin] using the */writehdrfile* option. Open the command line (Windows + cmd), navigate to the directory where the BIOS .exe file is and:

```
C:\Users\user\OneDrive\Desktop\Dell Vostro 5470 BIOS>5470A09.exe /writehdrfile

C:\Users\user\OneDrive\Desktop\Dell Vostro 5470 BIOS>

Extracting capsule...
BIOS.cap
BIOS_BIOS.bin from BIOS.cap
Completed.
```
This command line extracts the [BIOS.cap] from the [5470A12.exe], then the [BIOS_BIOS.bin] from the [BIOS.cap].

### ME binary file
Only the [BIOS.bin] file isn't enough, we'll need the Intel Management Engine [ME.bin] file as well. To extract the [ME.bin] we can use the /ext option of BIOS executable.

```
C:\Users\andre\OneDrive\Desktop\Dell Vostro 5470 BIOS>5470A09.exe /ext

C:\Users\andre\OneDrive\Desktop\Dell Vostro 5470 BIOS>

Extracting all files...
_DELLWIN32.bat
_DELLDOS.bat
BIOS.cap
BIOSChecker32.exe
BIOSChkD.exe
default.rsp
DosFlash.exe
EcIdle32.exe
EcIdleD.exe
EcWake32.exe
EcWakeD.exe
FWUpdL32.exe
FWUpdLcl.exe
ME.bin
SctWinFlash32.exe
WinFlash32.exe
Completed.
```

## References
[NEW DELL 16MB .HDR TO BIN EXTRACTION...|https://www.youtube.com/watch?v=vEr8dYtT0SQ]
[Extract Bios BIN file from EXE file|https://www.youtube.com/watch?v=wmQWUudBL6E]
[How to use me analyzer for bios bin file|https://www.youtube.com/watch?v=7s7dLo3P2ow]
[https://thetechstall.com/me-analyzer-v-1-98-0/]
