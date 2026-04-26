set terminal svg size 1920,380 dynamic font ",24" background rgb 'white'

set title "Release weekday heatmap" font ",48"

set datafile separator ","

# Clean look
unset border
unset key
unset colorbox

# Weeks on top (x2): 1..53
set xrange  [0.5:53.5]
set x2range [0.5:53.5]
unset xtics
set x2tics 1,1,53 \
  scale 0 offset 0,-0.5 font "Sans,22"

# Weekdays Mon..Sun, top-to-bottom
set yrange [7.5:0.5]
set ytics ("Mon" 1, "Tue" 2, "Wed" 3, "Thu" 4, "Fri" 5, "Sat" 6, "Sun" 7) \
  scale 0 offset 0,0 font "Sans,28"

# GitHub-ish palette (0 = empty gray)
set palette defined ( \
  0 "#ebedf0", \
  1 "#9be9a8", \
  2 "#40c463", \
  3 "#30a14e", \
  4 "#216e39", \
  5 "#0d4a20"  \
)
set cbrange [0:5]

# Sizes - tile_inner would normally equal tile_data
tile_outer = 0.78   # outer cell as border
tile_inner = 0.76   # inner gray cell
tile_data  = 0.76   # colored cell

border_col = "#d0d7de"   # outer border
empty_col  = "#ebedf0"   # empty tile fill

unset object

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.40, 0.15 width screen 0.20 behind

# Draw the full grid of "empty" cells
do for [w=1:53] {
  do for [d=1:7] {
    # outer cell as border
    set object rect from (w-tile_outer/2.0),(d-tile_outer/2.0) to (w+tile_outer/2.0),(d+tile_outer/2.0) \
      fc rgb border_col fs solid 1.0 noborder behind
    # inner gray cell
    set object rect from (w-tile_inner/2.0),(d-tile_inner/2.0) to (w+tile_inner/2.0),(d+tile_inner/2.0) \
      fc rgb empty_col fs solid 1.0 noborder behind
  }
}

set style fill solid 1.0 noborder

# Bucket values into 0..5, cap at 5 and ensure integer value
level(v) = (v <= 0 ? 0 : (v >= 5 ? 5 : int(v)))

# Plot values as colored squares using the boxxyerrorbars style (boxxy)
# The zero value is colored the same as an empty cell
plot ARG1.'/heatmap-releasedays.csv' using 1:2:(tile_data/2):(tile_data/2):(level($3)) \
  with boxxy lc palette notitle