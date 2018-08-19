local function split(str, delimiter)
   function f(s, var)
      if s.str == ""
      then
         return
      end
      local retval =  ""
      local looping_mode =  true
      while looping_mode
      do if s.str == ""
         then
            looping_mode =  false
         else
            local cur_char =  string.sub(s.str, 1, 1)
            if cur_char == delimiter
            then
               looping_mode =  false
            else
               retval =  retval .. cur_char
            end
            s.str =  string.sub(s.str, 2)
         end
      end
      return retval
   end
   return f, { ["str"] = str }
end

return split
