#!/usr/bin/awk -f
$2 < 0 { NEG =  NEG + $3 }
$2 > 0 { POS =  POS + $3 }
END {
   print("neg: ", NEG)
   print("pos: ", POS)
   print("rel: ", POS / (NEG + POS) * 100, "%") }
