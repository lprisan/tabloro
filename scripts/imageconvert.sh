#!/bin/bash

# Convert the board to something inside 2048x2048
convert -density 50 table.pdf -quality 90 4ts_table.png

# Convert separate cards to something that fits 150x220
for file in carte_rosse_Task_C-*.png; do convert $file -resize x220 small-$file; done

# Join the two sides of a cards
convert small-carte_rosse_Task_C-02.png small-carte_rosse_Task_C-01.png +append RosseScrivereRelazione.png
