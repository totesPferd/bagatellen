local function relsplit(str, delimiter, rel)
   function f(s, var)
      if s.str == ""
      then
         return
      end
      local retval_a =  ""
      local retval_b
      local arg_mode =  "a"
      local looping_mode =  true
      while looping_mode
      do if s.str == ""
         then
            looping_mode =  false
         else
            local cur_char =  string.sub(s.str, 1, 1)
            if arg_mode == "a" and cur_char == rel
            then
               arg_mode =  "b"
               retval_b =  ""
            elseif cur_char == delimiter
            then
               looping_mode =  false
            elseif arg_mode == "a"
            then
               retval_a =  retval_a .. cur_char
            elseif arg_mode == "b"
            then
               retval_b =  retval_b .. cur_char
            end
            s.str =  string.sub(s.str, 2)
         end
      end
      return retval_a, retval_b
   end
   return f, { ["str"] = str }
end

return relsplit
