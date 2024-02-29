# Weather Icons

These are anti-aliased single-color icons for weather conditions.

They are based on the SVG icons from https://github.com/erikflowers/weather-icons

They are pre-rendered as PNGs with 9 levels of transparency for the
anti-aliased edges.  Each is available in a compressed version and
an uncompressed version.  The compressed version saves ROM (flash)
space, while the uncompressed version saves RAM space.  The pixel data
is identical between the two versions.

They are designed to be used with the Png class from pixel-display
package: https://pkg.toit.io/github.com/toitware/toit-pixel-display@2.3.0/docs/pixel_display/png/class-Png  Since they are anti-aliased, they are
well-suited to true-color displays like ones supported by
https://github.com/toitware/toit-color-tft

Use the compressed version if you have lots of different icons and
only use a few at a time.  Use the uncompressed version if you have only
a few icons and want to use them at a large size, especially as a background.
If the foreground changes then a redraw will typically include part of the
backgound image.  An uncompressed background icon can be redrawn
directly from flash without using a lot of RAM or spending CPU time on
decompression.
