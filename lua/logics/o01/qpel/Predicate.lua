local Symbol =  require "logics.place.qsimple.Symbol"

local Predicate =  Symbol:__new()

package.loaded["logics.qpel.Predicate"] =  Predicate
local String =  require "base.type.String"

function Predicate:get_name()
   local retval =  self:get_base():get_name():__clone()
   retval:append_string(String:string_factory("."))
   retval:append_string(self:get_qualifier():get_name())
   return retval
end

return Predicate
