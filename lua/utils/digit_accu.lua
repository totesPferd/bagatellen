local digit_accu = (require "base.oop.obj"):__new()
function digit_accu:new(radix)
   local retval =  self:__new()
   retval.radix =  radix or 16
   retval.accu =  0
   return retval
end

function digit_accu:next_digit(digit)
   local v =  string.byte(digit, 1, -1)
   local num_digit
   local retval =  true
   if v >= 0x30 and v <= 0x39
   then
      num_digit =  v - 0x30
   elseif v >= 0x41 and v <= 0x46
   then
      num_digit =  v - 0x37
   elseif v >= 0x61 and v <= 0x66
   then
      num_digit =  v - 0x57
   else
      retval =  false
   end
   if num_digit >= self.radix
   then
      retval =  false
   else
      self.accu =  self.radix * self.accu + num_digit
   end
   return retval
end

function digit_accu:reset()
   self.accu =  0
end

return digit_accu
