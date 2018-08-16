local function regex_quote(s)
   local t =  { string.byte(s, 1, -1) }
   local retval =  ""
   for i, v in pairs(t)
   do local c =  string.char(v)
      if
            (c == "^")
         or (c == "$")
         or (c == "(")
         or (c == ")")
         or (c == "%")
         or (c == ".")
         or (c == "[")
         or (c == "]")
         or (c == "*")
         or (c == "+")
         or (c == "-")
         or (c == "?")
      then
         retval =  retval .. "%" .. c
      else
         retval =  retval .. c
      end
   end

   return retval
end

return regex_quote
