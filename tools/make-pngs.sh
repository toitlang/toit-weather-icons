#!/bin/sh

set -e

for size in 32 36 40 48 56 64 72 80 96 112 128 144 160 192 224 256
do
  mkdir -p src/png-$size
  echo $size
  for svg in `(cd third_party/weather-icons/svg && ls *.svg)`
  do
    name=${svg%.svg}
    NAME=`echo $name | tr a-z A-Z`
    echo $name $size
    resvg -w $size -h $size third_party/weather-icons/svg/$name.svg out.png
    pngquant --strip --nofs -f 9 out.png
    pngout -c3 out.png
    echo "/// PNG file for $name, size ${size}x$size." > src/png-$size/$name.toit
    xxd -i -n foo out-or8.png | \
        sed 's/^unsigned char.*'"/$NAME ::= #[/" | \
        sed '/^unsigned int/d' | \
        sed 's/};/]/' >> \
        src/png-$size/$name.toit
    exit 0
  done
done

