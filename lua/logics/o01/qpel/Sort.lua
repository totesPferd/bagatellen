local Symbol =  require "logics.place.qsimple.Symbol"

local Sort =  Symbol:__new()

package.loaded["logics.qpel.Sort"] =  Sort
local String =  require "base.type.String"

function Sort:is_system(system)
   if system == "qsimple"
   then
      return self
   end
end

function Sort:get_name()
   local retval =  self:get_base():get_name():__clone()
   retval:append_string(String:string_factory("."))
   retval:append_string(self:get_qualifier():get_name())
   return retval
end

return Sort
