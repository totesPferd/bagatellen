local Type =  require "base.type.aux.Type"

local Sort =  Type:__new()

package.loaded["logics.pel.Sort"] =  Sort

function Sort:new(module_instance, name)
   local retval =  self:__new()
   retval.module_instance =  module_instance
   retval.name =  name
   return retval
end

function Sort:is_system(system)
   if system == "qsimple"
   then
      return self
   end
end

function Sort:get_module_instance()
   return self.module_instance
end

function Sort:get_name()
   return self.name
end

return Sort
