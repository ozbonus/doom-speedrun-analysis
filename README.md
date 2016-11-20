# doom-speedrun-analysis

An incomplete set of tools for extracting data from Classic Doom speedruns.

# Requirements

A Linux machine with `libav-tools`, `tesseract-ocr` and `imagemagick`, until the Python components are added.

# Usage

Run `./pull-data.sh movie` where `movie` is a recording of a Classic Doom speedrun made with OCR.wad. A file named `data.csv` will be output to the script directory.

# pull-data.sh

This script takes a video of Classic Doom gameplay as input and extracts each frame into a temporary directory. Imagemagick then extracts key areas of each frame. Next, Tesseract performs and OCR operation on each image. Finally, all of this is wrapped up in a nice little file.

It is not an elegant script. I predominantly wrote it in order to practice writing something in bash. The most valuable lesson I learned was that I don't like bash.

# data.csv

The data file output by the script comprises four columns: `health`, `armor`, `level`, and `progress`, polled twice per second from gameplay. Here's what the columns represent:

* `health`: The health value of the player.
* `armor`: The armor value of the player.
* `level`: The name of the level being entered or exited.
* `progress`: Whether a player is "Leaving" or "Entering" a level.

# How to Prepare a Speedrun

First, acquire a demo that interests you in `lmp` format. A good place to look is [The DooMed Speed Demos Archive](doomedsda.us).

You will need to run the demo with the OCR pwad enabled while recording playback as a video file. Imagemagick can handle a wide range of video formats.

The extraction script assumes that the video file will be 800x600 and 2fps. [OBS Studio](obsproject.com) is a free, open source, and cross-platform program that does a good job of this.

# OCR.wad

This pwad makes key game texts more OCR-friendly. It also modifies PLAYPAL palettes 2 through 14 to be equivalent to palette 1, which stops the red flash indicating damage (It was messing with OCR).
