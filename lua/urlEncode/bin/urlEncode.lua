#!/usr/bin/env lua

for _, c in pairs { string.byte(io.stdin:read("*a"), 1, -1) }
do if
         c == 0x2d
      or c == 0x2e
      or c >= 0x30 and c <= 0x39
      or c >= 0x41 and c <= 0x5a
      or c == 0x5f
      or c >= 0x61 and c <= 0x7a
      or c == 0x7e
   then
      io.stdout:write(string.char(c))
   elseif
         c == 0x20
   then
      io.stdout:write("+")
   else
      io.stdout:write(string.format("%%%02x", c))
   end
end
