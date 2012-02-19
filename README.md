`make-jpkg` is a simple collection of scripts that can help you create a Debian
 package (.deb) from a generic Sun Java SE 6 package for Linux (.bin).

## A very short HOWTO using Sun JDK 6u30 as an example

1. install the tools needed to build the .deb package

        # apt-get install debhelper fakeroot

2. install the packages that are needed by JDK 6

        # apt-get install java-common locales unixodbc
        # apt-get install libasound2 libx11-6 libxext6 libxi6 libxt6 libxtst6

3. download `make-jpkg` project from github and unpack it (or just clone it)

4. download Java SE 6 (JDK) package from java.sun.com

5. create the .deb package using `make-jpkg` script

        u@H:~$ export J2SE_PACKAGE_FULL_NAME="Your NAME"
        u@H:~$ export J2SE_PACKAGE_EMAIL="your@email.address"
        u@H:~$ fakeroot ./make-jpkg jdk-6u30-linux-x64.bin

6. install the .deb package that was just generated

        # dpkg -i .../j2sdk1.6-sun_1.6.0+u30_amd64.deb


## For who is this tool?

This tool is meant to be used only by those who are forced to use Sun Java SE 6
for Linux on Debian. If possible, I strongly **recommend** to use OpenJDK
packages which are of a higher quality.


## Why is this tool necessary?

The script `make-jpkg` is needed due to removal of `sun-java6` package from
Debian \([Bug#646524](http://bugs.debian.org/646524)\).
