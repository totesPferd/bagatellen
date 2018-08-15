local function leq(s, t)
   if type(s) == "table" and type(t) == "table"
   then
      for k, v in pairs(s)
      do if not leq(v, t[k])
         then
            return false
         end
      end
      return true
   else
      return s == t
  end
end

return leq
