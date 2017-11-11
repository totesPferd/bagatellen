local Symbol =  require "logics.place.simple.Symbol"

local Predicate =  Symbol:__new()

package.loaded["logics.pel.Predicate"] =  Predicate

function Predicate:new(module_instance, name)
   local retval =  Symbol.new(self)
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
