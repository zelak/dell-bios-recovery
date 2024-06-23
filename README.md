# dell-bios-recovery
How to extract Dell BIOS from exe file and write into the EEPROM.

First, this post is only for educational purposes. We're not responsible for any loss or damages. Use at your own risk. 

## Prerequisites
Download Hex Workshop from BreakPoint Software website (http://www.bpsoft.com/downloads/) and install.

## Download BIOS exe file
At Dell Support page (https://www.dell.com/support/home/pt-br) search by device's service tag. Mine Vostro 5470 service tag is 5Y5Q442. Then at Drivers tab download the latest driver available.

## Extract the BIOS binary file
There are some tutorial online, they usually uses Batch or Python scripts to extract the BIOS and ME binary files. See #References bellow. I

On my
For the Vostro 5470 exe file first we extract the BIOS .cap file then the .bin from .cap; 

## References
[NEW DELL 16MB .HDR TO BIN EXTRACTION...|https://www.youtube.com/watch?v=vEr8dYtT0SQ]
[Extract Bios BIN file from EXE file|https://www.youtube.com/watch?v=wmQWUudBL6E]
