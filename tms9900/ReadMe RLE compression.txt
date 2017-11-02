Convert9918 - A simple image converter for the TMS9918A
-------------------------------------------------------

Really basic - launch it, then either click 'open' or drag and
drop your image file onto the window. It will be converted for
the 9918A's Graphics II mode (Bitmap). There are no options for
other modes.

The current palette is based on the Classic99 palette.

There are a few controls available once the image is loaded:

-Nudge Right & Left - because Bitmap mode has color 
limitations for every 8 horizontal pixels, you can sometimes 
get a better result by shifting a few pixels. It never makes
sense to shift more than 7 pixels, so the program will stop
there. Usually after 4 pixels you are better off trying the
other direction. Loading a new image clears the nudge count.

-Nudge Up & Down - these shift the image up and down one pixel
at a time. Hold Shift for two pixels at a time, hold control for
4 at a time, and hold shift and control together for 8 at a time.
Up and Down refers to the virtual 'camera' direction and only
applies if the image is larger than the display due to one of 
the 'Fill Mode's in the options being set. Scrolling farther
than is possible will simply make it stop moving - the counter
will still change. You can see this in the output text window.
Loading a new image clears the nudge count.

-Stretch Hist (Hist) - this stretches the histogram of the 
image to improve contrast and enhance colors. It can also cause 
a pretty severe color shift, but in some cases it helps the 
detail of the image.

-Use Perceptual Color matching (Perc) - this changes the color
matching system to favour a model of human color visibility,
giving green the most importance, red second, and blue third.
This can often improve an image and provide more pleasing 
results, but it tends to introduce a blue shift in dark areas.

-Options - This system uses Floyd-Steinberg 
to improve the apparent color accuracy of the image. You
can change the error distribution in the dialog. Each
value indicates the ratio, out of 16, of the error that
goes to that pixel. Some suggested values:

DEFAULT    OLD 50%    Old 100%   NEW 50%    HalfTone   No Dist
  PIX 7      PIX 0      PIX 0      PIX 3      PIX 1      PIX 0
3  5  1    3  5  1    5  9  2    1  2  0    0  1  0    0  0  0     

Note that if the total of all values entered is less than 16,
some of the error will be lost. If the value is more than 16,
errors will accumulate and you will probably get large blocks
of white and black and other errors.

This dialog also allows you to choose between various
resizing filters, the default is bilinear.

It also has a dropdown for a 'fill mode'. This affects images
which are not in a 3:2 ratio. In Full mode (the default), the
entire image is scaled to fit. Otherwise, the image is scaled
so that the smaller axis fits the screen, and the rest is
cropped off based on your setting, which can be top/left,
middle, or bottom/right (the setting is what part is kept).

-Open - opens a new file. Many image types including TI Arist
are supported.

-Save Pic - saves the color and pattern data. The filename
you enter has _P and _C appended to it, respectively.

Six file types are available:

TIFILES - this is useful for transfer to a real TI, or for
use with Classic99. This header is 128 bytes.

V9T9 - this puts a V9T9 header on the file. This file format
is largely obsolete and I don't recommend using it unless
you know why you need it. This header is 128 bytes. These
files will only use the first 6 characters of the filename.

RAW - no header is attached. Just a raw binary dump of the
color table and pattern table.

RLE - no header is attached. The files are RLE encoded as such:
Count Byte: 
	- if high bit is set, remaining 7 bits indicate to copy
	the next byte that many times
	- if high bit is clear, remaining 7 bits indicate how
	many data bytes (non-repeated) follow
RLE compression will probably not be useful on complex images.

XB Program - saves as an Extended BASIC program with a TIFILES header.
This program displays the image and waits for the user to press
enter. The image and assembly are all saved with the program.

XB RLE Program - also saves as an Extended BASIC program with a
TIFILES header, but RLE compresses the image.

If you are using an emulator, Classic99 can read the TIFILES 
or V9T9 files directly into TI Artist or another paint program. 
(TI Artist under Classic99 can load filenames much longer
than 10 characters!)

A Special mode also exists where you can randomly
browse an entire folder (this was me being silly). 
Double click anywhere on the dialog where there is no
button, and 'Open' will become 'Next'. Click it, and
select a file in a folder you would like to browse.
All images in that folder (and all subfolders) will
be available in random order each time you click 'Next'.
You can process and save any you like. To exit this
mode you must close the program.

Source code is not available as this program uses
the ImgSource Library by Smaller Animals Software.

//
// (C) 2011 Mike Brent aka Tursi aka HarmlessLion.com
// This software is provided AS-IS. No warranty
// express or implied is provided.
//
// This notice defines the entire license for this software.
// All rights not explicity granted here are reserved by the
// author.
//
// You may redistribute this software provided the original
// archive is UNCHANGED and a link back to my web page,
// http://harmlesslion.com, is provided as the author's site.
// It is acceptable to link directly to a subpage at harmlesslion.com
// provided that page offers a URL for that purpose
//
// Source code, if available, is provided for educational purposes
// only. You are welcome to read it, learn from it, mock
// it, and hack it up - for your own use only.
//
// Please contact me before distributing derived works or
// ports so that we may work out terms. I don't mind people
// using my code but it's been outright stolen before. In all
// cases the code must maintain credit to the original author(s).
//
// Unless you have explicit written permission from me in advance,
// this code may never be used in any situation that changes these
// license terms. For instance, you may never include GPL code in
// this project because that will change all the code to be GPL.
// You may not remove these terms or any part of this comment
// block or text file from any derived work.
//
// -COMMERCIAL USE- Contact me first. I didn't make
// any money off it - why should you? ;) If you just learned
// something from this, then go ahead. If you just pinched
// a routine or two, let me know, I'll probably just ask
// for credit. If you want to derive a commercial tool
// or use large portions, we need to talk. ;)
//
// Commercial use means ANY distribution for payment, whether or
// not for profit.
//
// If this, itself, is a derived work from someone else's code,
// then their original copyrights and licenses are left intact
// and in full force.
//
// http://harmlesslion.com - visit the web page for contact info
//

