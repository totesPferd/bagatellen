#!/usr/bin/env lua

for l in io.stdin:lines()
do local capMode =  false
   local qMode =  false
   local outputLine = ""
   for _, b in pairs { l:byte(1, -1) }
   do
      if b == 81
      then
         if qMode and xMode
         then
            outputLine =  outputLine .. string.char(b)
         else
            qMode =  true
            capMode =  true
         end
      elseif b == 113
      then
         if qMode and xMode
         then
            outputLine =  outputLine .. string.char(b)
         else
            qMode =  true
            capMode =  false
         end
      elseif xMode
      then
         if qMode
         then
            qMode =  false
            outputLine =  outputLine .. string.char(b)
         elseif b == 88
         then
            xMode =  false
            capMode =  true
         elseif b == 120
         then
            xMode =  false
            capMode =  false
         else
            outputLine =  outputLine .. string.char(b)
         end
      else
         if b == 65
         then
            outputLine =  outputLine .. '\208\144'
            qMode =  false
         elseif b == 66
         then
            outputLine =  outputLine .. '\208\145'
            qMode =  false
         elseif b == 67
         then
            outputLine =  outputLine .. '\208\166'
            qMode =  false
         elseif b == 68
         then
            outputLine =  outputLine .. '\208\148'
            qMode =  false
         elseif b == 69
         then
            outputLine =  outputLine .. '\208\149'
            qMode =  false
         elseif b == 70
         then
            outputLine =  outputLine .. '\208\164'
            qMode =  false
         elseif b == 71
         then
            outputLine =  outputLine .. '\208\147'
            qMode =  false
         elseif b == 72
         then
            outputLine =  outputLine .. '\208\172'
            qMode =  false
         elseif b == 73
         then
            outputLine =  outputLine .. '\208\152'
            qMode =  false
         elseif b == 74
         then
            outputLine =  outputLine .. '\208\153'
            qMode =  false
         elseif b == 75
         then
            outputLine =  outputLine .. '\208\154'
            qMode =  false
         elseif b == 76
         then
            outputLine =  outputLine .. '\208\155'
            qMode =  false
         elseif b == 77
         then
            outputLine =  outputLine .. '\208\156'
            qMode =  false
         elseif b == 78
         then
            outputLine =  outputLine .. '\208\157'
            qMode =  false
         elseif b == 79
         then
            outputLine =  outputLine .. '\208\158'
            qMode =  false
         elseif b == 80
         then
            outputLine =  outputLine .. '\208\159'
            qMode =  false
         elseif b == 82
         then
            outputLine =  outputLine .. '\208\160'
            qMode =  false
         elseif b == 83
         then
            outputLine =  outputLine .. '\208\161'
            qMode =  false
         elseif b == 84
         then
            outputLine =  outputLine .. '\208\162'
            qMode =  false
         elseif b == 85
         then
            outputLine =  outputLine .. '\208\163'
            qMode =  false
         elseif b == 86
         then
            outputLine =  outputLine .. '\208\146'
            qMode =  false
         elseif b == 88
         then
            xMode =  true
            capMode =  true
         elseif b == 89
         then
            outputLine =  outputLine .. '\208\171'
            qMode =  false
         elseif b == 90
         then
            outputLine =  outputLine .. '\208\151'
            qMode =  false
         elseif b == 97
         then
            if qMode
            then
               if capMode
               then
                  outputLine =  outputLine .. '\208\175'
               else
                  outputLine =  outputLine .. '\209\143'
               end
            else
               outputLine =  outputLine .. '\208\176'
            end
            qMode =  false
         elseif b == 98
         then
            outputLine =  outputLine .. '\208\177'
            qMode =  false
         elseif b == 99
         then
            if qMode
            then
               if capMode
               then
                  outputLine =  outputLine .. '\208\167'
               else
                  outputLine =  outputLine .. '\209\135'
               end
            else
               outputLine =  outputLine .. '\209\134'
            end
            qMode =  false
         elseif b == 100
         then
            outputLine =  outputLine .. '\208\180'
            qMode =  false
         elseif b == 101
         then
            if qMode
            then
               if capMode
               then
                  outputLine =  outputLine .. '\208\173'
               else
                  outputLine =  outputLine .. '\209\141'
               end
            else
               outputLine =  outputLine .. '\208\181'
            end
            qMode =  false
         elseif b == 102
         then
            outputLine =  outputLine .. '\209\132'
            qMode =  false
         elseif b == 103
         then
            outputLine =  outputLine .. '\208\179'
            qMode =  false
         elseif b == 104
         then
            if qMode
            then
               if capMode
               then
                  outputLine =  outputLine .. '\208\170'
               else
                  outputLine =  outputLine .. '\209\138'
               end
            else
               outputLine =  outputLine .. '\209\140'
            end
            qMode =  false
         elseif b == 105
         then
            outputLine =  outputLine .. '\208\184'
            qMode =  false
         elseif b == 106
         then
            outputLine =  outputLine .. '\208\185'
            qMode =  false
         elseif b == 107
         then
            if qMode
            then
               if capMode
               then
                  outputLine =  outputLine .. '\208\165'
               else
                  outputLine =  outputLine .. '\209\133'
               end
            else
               outputLine =  outputLine .. '\208\186'
            end
            qMode =  false
         elseif b == 108
         then
            outputLine =  outputLine .. '\208\187'
            qMode =  false
         elseif b == 109
         then
            outputLine =  outputLine .. '\208\188'
            qMode =  false
         elseif b == 110
         then
            outputLine =  outputLine .. '\208\189'
            qMode =  false
         elseif b == 111
         then
            if qMode
            then
               if capMode
               then
                  outputLine =  outputLine .. '\208\129'
               else
                  outputLine =  outputLine .. '\209\145'
               end
            else
               outputLine =  outputLine .. '\208\190'
            end
            qMode =  false
         elseif b == 112
         then
            outputLine =  outputLine .. '\208\191'
            qMode =  false
         elseif b == 114
         then
            if qMode
            then
               if capMode
               then
                  outputLine =  outputLine .. '\208\169'
               else
                  outputLine =  outputLine .. '\209\137'
               end
            else
               outputLine =  outputLine .. '\209\128'
            end
            qMode =  false
            capMode =  false
         elseif b == 115
         then
            if qMode
            then
               if capMode
               then
                  outputLine =  outputLine .. '\208\168'
               else
                  outputLine =  outputLine .. '\209\136'
               end
            else
               outputLine =  outputLine .. '\209\129'
            end
            qMode =  false
            capMode =  false
         elseif b == 116
         then
            outputLine =  outputLine .. '\209\130'
            qMode =  false
         elseif b == 117
         then
            if qMode
            then
               if capMode
               then
                  outputLine =  outputLine .. '\208\174'
               else
                  outputLine =  outputLine .. '\209\142'
               end
            else
               outputLine =  outputLine .. '\209\131'
            end
            qMode =  false
         elseif b == 118
         then
            outputLine =  outputLine .. '\208\178'
            qMode =  false
         elseif b == 120
         then
            xMode =  true
            capMode =  false
         elseif b == 121
         then
            outputLine =  outputLine .. '\209\139'
            qMode =  false
         elseif b == 122
         then
            if qMode
            then
               if capMode
               then
                  outputLine =  outputLine .. '\208\150'
               else
                  outputLine =  outputLine .. '\208\182'
               end
            else
               outputLine =  outputLine .. '\208\183'
            end
            qMode =  false
         else
            outputLine =  outputLine .. string.char(b)
            qMode =  false
         end
      end
   end
   print(outputLine)
end

os.exit(0)

