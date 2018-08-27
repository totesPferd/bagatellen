local digit_accu =  require "utils.digit_accu"
local regex_quote =  require "utils.regex_quote"

local function unquote(s_in)
   local s_out =  ""
   local t_in =  { string.byte(s_in, 1, -1) }
   local mode =  "char"
   local digits =  digit_accu:new()
   for k, v in pairs(t_in)
   do local c =  string.char(v)
      if mode == "char" and c == "%"
      then
         mode =  "first_digit"
      elseif mode == "char"
      then
         s_out =  s_out .. c
      elseif mode == "first_digit"
      then
         mode =  "second_digit"
         digits:next_digit(c)
      elseif mode == "second_digit"
      then
         mode =  "char"
         digits:next_digit(c)
         s_out =  s_out .. string.char(digits.accu)
         digits:reset()
      end
   end
      
   return s_out
end

return unquote
