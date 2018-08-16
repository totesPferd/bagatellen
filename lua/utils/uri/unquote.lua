local regex_quote =  require "utils.regex_quote"

local digit_accu = (require "base.oop.obj"):__new()
function digit_accu:new()
   local retval =  self:__new()
   retval.accu =  0
   return retval
end

function digit_accu:next_digit(digit)
   local v =  string.byte(digit, 1, -1)
   local num_digit
   if v >= 0x30 and v <= 0x39
   then
      num_digit =  v - 0x30
   elseif v >= 0x41 and v <= 0x46
   then
      num_digit =  v - 0x37
   elseif v >= 0x61 and v <= 0x66
   then
      num_digit =  v - 0x57
   end
   self.accu =  16 * self.accu + num_digit
end

function digit_accu:reset()
   self.accu =  0
end

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
