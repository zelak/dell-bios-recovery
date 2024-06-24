# dell-bios-recovery
How to extract Dell BIOS from exe file and write into the EEPROM.

First, this post is only for educational purposes. We're not responsible for any loss or damages. Use at your own risk. 

## Prerequisites
1. You need a EEPROM Programmer like the [CH341A|https://pt.aliexpress.com/i/32787398455.html].
2. Download Hex Workshop from BreakPoint Software website (http://www.bpsoft.com/downloads/) and install.

## Downloading BIOS exe file
At Dell Support page (https://www.dell.com/support/home/pt-br) search by device's service tag. Mine Vostro 5470 service tag is 5Y5Q442. Then at Drivers tab download the latest driver available.

## Extracting the BIOS binary file
There are some tutorials online, they usually uses a Batch or a Python script to extract the BIOS and ME binary files. See #References bellow. I read the scripts, tested some options with [5470A12.exe] and created my own way to extract them.

### BIOS binary file
First we extract the [BIOS.cap] and the [BIOS_BIOS.bin] using the **/writehdrfile** option. Open the command line (Windows + cmd), navigate to the directory where the BIOS .exe file is and:

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

## Creating the new BIOS image
Now we have the **BIOS.bin** and the **ME.bin** files extracted we need to replaced them into the backup BIOS image read from the EEPROM.
I renamed the files [5470A12_BIOS.bin] and [5470A12_ME.bin] respectively.

### Backup the EEPROM
Using the EEPROM Programmer read the content from the notebook's BIOS EEPROM and save two copies I called [5470A12_BIOS-orig.bin] and 5470A12_BIOS-backup.bin. One of the copies we store as a backup, and the second copy we'll use as base to the new BIOS image.

### Replacing the BIOS
Open the copy of the original BIOS image [5470A12_BIOS-orig.bin] in Hex Workshop, then open the [5470A12_BIOS.bin] too.

Each file will apear in a tab below the data window, select the BIOS.bin tab and look at the first 4 bytes.
The [5470A_BIOS.bin] starts with 02 02 70 02, select them and copy.
Then go to [5470A12_BIOS-orig.bin] and search for this hex sequence using Edit > Find... (Ctrl+F). It will point the start of the BIOS image in the EEPROM. In the 5470 image the 02 02 70 02 sequence is in the 0x00180000 offset.

Now go back to [5470A_BIOS.bin] and select all the data (Ctrl+A) then copy (Ctrl+C).
Take a note of the selection size in the **Sel:** box in the bottom right corner of the Hex Workshop window.
The 5470A12_BIOS.bin is 0x680000

Then go to [5470A12_BIOS-orig.bin], put the cursor before the 02 02 70 02 and select a block Edit > Select Block. Select Hex and type the block size, 680000 then click Ok. Then paste the data (Ctrl+V).

If a warning box appears telling Undo feature cannot be used due to the size of the data replaced, hit OK.

Now save as different name using File > Save As... . I save as [5470A_BIOS-to-write.bin].

### Replacing the ME region
To replace the ME region, repeat the same procedure.

Open the [5470A12_ME.bin] file and select the first 4 bytes: 20 20 80 0F.

Then search for 2020800F in [5470A_BIOS-to-write.bin]. I found them at 0x1000 offset.

Select all the data on [5470A12_ME.bin], copy and take a note of its size (0x17D000).

In [5470A_BIOS-to-write.bin, starting at 0x1000 offset select a block of 0x17D000 size. Then paste the data.

At last, save the file.

## Writing the EEPROM
The last step is to write and verify the data on the EEPROM.

Follow the EEPROM Programmer user guide.

## References
[NEW DELL 16MB .HDR TO BIN EXTRACTION...|https://www.youtube.com/watch?v=vEr8dYtT0SQ]

[Extract Bios BIN file from EXE file|https://www.youtube.com/watch?v=wmQWUudBL6E]

[How to use me analyzer for bios bin file|https://www.youtube.com/watch?v=7s7dLo3P2ow]

[https://thetechstall.com/me-analyzer-v-1-98-0/]
