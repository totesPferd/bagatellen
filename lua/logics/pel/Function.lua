local Symbol =  require "logics.place.simple.Symbol"

local Function =  Symbol:__new()

package.loaded["logics.pel.Function"] =  Function

function Function:new(module_instance, sort, name)
   local retval =  Symbol.new(self)
   retval.module_instance =  module_instance
   retval.name =  name
   retval.sort =  sort
   return retval
end

function Function:get_module_instance()
   return self.module_instance
end

function Function:get_name()
   return self.name
end

function Function:get_sort()
   return self.sort
end

return Function
