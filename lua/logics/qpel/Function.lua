local Symbol =  require "logics.place.qsimple.Symbol"

local Function =  Symbol:__new()

package.loaded["logics.qpel.Function"] =  Function
local Sort =  require "logics.qpel.Sort"
local String =  require "base.type.String"

function Function:get_name()
   local retval =  self:get_base():get_name():__clone()
   retval:append_string(String:string_factory("."))
   retval:append_string(self:get_qualifier():get_name())
   return retval
end

function Function:get_sort()
   local base =  self:get_base():get_sort()
   local qualifier =  self:get_qualifier()
   return Sort:qualifying_factory(base, qualifier)
end

return Function
