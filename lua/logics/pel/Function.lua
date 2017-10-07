local Type =  require "base.type.aux.Type"

local Function =  Type:__new()

package.loaded["logics.pel.Function"] =  Function

function Function:new(module_instance, sort, name)
   local retval =  Function:__new()
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
