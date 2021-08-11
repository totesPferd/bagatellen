param nrRows;
param nrCols;
set InputBuf;
param InputElem{ InputBuf, 1..nrRows, 1..nrCols };
set Channel := { 'r', 'g', 'b', 'a' };
var ColorAmpl{ InputBuf };
param ColorAssign{ InputBuf, Channel };
param BaseColor{ Channel };
var OutputElem{ Channel, 1..nrRows, 1..nrCols } >= 0.0, <= 255.9999;
s.t. c001{ i in InputBuf, m in 1..nrRows, n in 1..nrCols }:
   1.0 / card(InputBuf) <= ColorAmpl[i] * InputElem[i, m, n] <= 1.0;
s.t. c002{ c in Channel, m in 1..nrRows, n in 1..nrCols }:
   OutputElem[c, m, n] ==
   BaseColor[c] +
      sum{ i in InputBuf } ColorAmpl[i] * InputElem[i, m, n] * ColorAssign[i, c];
maximize o: sum{ i in InputBuf } ColorAmpl[i];

solve;


end;
