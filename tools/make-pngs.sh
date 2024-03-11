#!/bin/sh

# Copyright (C) 2024 Toitware ApS.
# Use of this source code is governed by an MIT-style license that can be
# found in the LICENSE_TOOLS file.

# Requires in your path:
#  resvg from https://github.com/RazrFalcon/resvg
#  pngquant, available in AUR.
#  pngout, available in AUR.
#  pngunzip, from https://github.com/toitware/toit-png-tools/releases

PNGUNZIP="toit.run $HOME/toitware/toit-png-tools/bin/pngunzip.toit"

set -e

for size in 32 36 40 48 56 64 72 80 96 112 128 144 160 192 224 256
do
  mkdir -p src/png-$size
  echo $size
  for svg in `(cd third_party/weather-icons/svg && ls *.svg)`
  do
    name=${svg%.svg}
    name=`echo $name | sed 's/wi-//'`
    NAME=`echo $name | tr a-z A-Z`
    echo $name $size
    # Convert from SVG to PNG.
    resvg -w $size -h $size third_party/weather-icons/svg/wi-$name.svg out.png
    # Reduce to 9 levels of transparency.
    pngquant --strip --nofs -f 9 out.png
    # Recompress and force to mode 3 (palette).
    pngout -c3 out.png
    $PNGUNZIP -o unzipped.png out-or8.png
    echo "/// PNG file for $name, size ${size}x$size." > src/png-$size/$name.toit
    echo "/// Generated from https://raw.githubusercontent.com/erikflowers/weather-icons/master/svg/wi-$name.svg" >> src/png-$size/$name.toit
    echo "/// ROM size" `stat -c %s out-or8.png` "bytes." >> src/png-$size/$name.toit
    echo "/// RAM size" `stat -c %s unzipped.png` "bytes." >> src/png-$size/$name.toit
    xxd -i -n foo out-or8.png | \
        sed 's/^unsigned char.*'"/$NAME ::= #[/" | \
        sed '/^unsigned int/d' | \
        sed 's/};/]/' >> \
        src/png-$size/$name.toit
    echo >> src/png-$size/$name.toit
    echo "/// Uncompressed (random-access) PNG file for $name, size ${size}x$size." >> src/png-$size/$name.toit
    echo "/// Generated from https://raw.githubusercontent.com/erikflowers/weather-icons/master/svg/wi-$name.svg" >> src/png-$size/$name.toit
    echo "/// ROM size" `stat -c %s unzipped.png` "bytes." >> src/png-$size/$name.toit
    xxd -i -n foo unzipped.png | \
        sed 's/^unsigned char.*'"/$NAME-UNCOMPRESSED ::= #[/" | \
        sed '/^unsigned int/d' | \
        sed 's/};/]/' >> \
        src/png-$size/$name.toit
    cp out-or8.png src/png-$size/$name.png
  done
done

