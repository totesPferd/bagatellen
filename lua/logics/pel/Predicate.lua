local Type =  require "base.type.aux.Type"

local Predicate =  Type:__new()

package.loaded["logics.pel.Predicate"] =  Predicate

function Predicate:new(module_instance, name)
   local retval =  Predicate:__new()
   retval.module_instance =  module_instance
   retval.name =  name
   return retval
end

function Predicate:get_module_instance()
   return self.module_instance
end

function Predicate:get_name()
   return self.name
end

return Predicate
