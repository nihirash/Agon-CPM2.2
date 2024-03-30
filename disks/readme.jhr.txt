Images a-g and p are downloaded from nihirash github
Note image g contains zrok and hitchiker adventure games
I created Image j to contain scott adams adventure games

Included is a test program, RNDTST.ASM compiled to RNDTST.COM.  It
reads the R register and displays the raw contents as a decimal
number.  If the results don't change at all (typically always zero)
or are above 128 all the time, then this system will not be able to
run ADVENTUR.COM.

I downloaded cpmtools from https://github.com/lipro-cpm4l/cpmtools
I built and installed cpmtools under cygwin and added the windoes path to cygrive/c/use/local/bin

Run ./build.sh from a cygwin shell to create the dsk images.
