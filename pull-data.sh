#!/bin/bash


FILE=$1
WORKSPACE=/dev/shm/doom


extract_images() {
    avconv -i $FILE -r 2 -f image2 $WORKSPACE/%06d.png
}


# Assume that the images are 800x600.
# $1 - Crop region and new directory name.
crop () {
  # Tell ImageMagick where to crop based on parameter input.
  case $1 in
    health)
      local region='110x55+115+510'
      ;;
    armor)
      local region='110x55+440+510'
      ;;
    level)
      local region='500x60+150+6'
      ;;
  esac
  # Make a directory to store the cropped images.
  mkdir $WORKSPACE/$1
  # Crop every frame in the $WORKSPACE directory.
  for f in $WORKSPACE/*.png
  do
    echo "Cropping the $1 region from $(basename $f)"
    convert -crop $region $f $WORKSPACE/$1/$(basename $f)
  done
  echo "Finished cropping $1"
}


# $1 - Directory name.
ocr() {
  case $1 in
    health|armor)
      local psm=8
      local whitelist="0123456789"
      ;;
    level)
      local psm=7
      local whitelist="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      ;;
  esac
  local counter=1
  echo $1 > $WORKSPACE/$1.txt
  for f in $WORKSPACE/$1/*.png
  do
    local ocr=$(tesseract $f stdout -c tessedit_char_whitelist=$whitelist -psm $psm 2>/dev/null)
    echo "Writing frame $counter $1 value to $WORKSPACE/$1.txt: $ocr"
    echo "$ocr" >> $WORKSPACE/$1.txt
    counter=$(($counter+1))
  done
  echo "Finished ocr for $1"
}


combine() {
  paste -d, $WORKSPACE/*.txt > data.csv
}


cleanup() {
  echo "Cleaning up temporary files..."
  rm -rf $WORKSPACE
  echo "Done"
}


main() {
  ((!$#)) && echo "You must specify a video." && exit 1
  mkdir $WORKSPACE 2>/dev/null
  extract_images
  for i in health armor level; do crop $i; ocr $i; done
  combine
  cleanup
}


main "$@"
