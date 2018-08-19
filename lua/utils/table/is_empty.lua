local function is_empty(s)
   local retval =  false
   if type(s) == "table"
   then
      retval =  true
      for k, v in pairs(s)
      do retval =  false
      end
   end
   return retval
end

return is_empty
