local leq =  require "utils.table.leq"

local function eq(s, t)
   if type(s) == "table" and type(t) == "table"
   then
      return leq(s, t) and leq(t, s)
   else
      return s == t
   end
end

return eq
