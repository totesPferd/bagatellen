local function clone(t)
   local retval
   if type(t) == "table"
   then
      retval =  {}
      for k, v in pairs(t)
      do retval[k] =  clone(v)
      end
   else
      retval = t
   end
   return retval
end

return clone
