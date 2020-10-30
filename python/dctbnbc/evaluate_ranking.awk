#!/usr/bin/awk -f
$2 < THRESHOLD { NEG =  NEG + $3 }
$2 >= THRESHOLD { POS =  POS + $3 }
END {
   print("neg: ", NEG)
   print("pos: ", POS)
   print("rel: ", POS / (NEG + POS) * 100, "%") }
