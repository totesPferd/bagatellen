local Type =  require "base.type.aux.Type"

local Variable =  Type:__new()

package.loaded["logics.pel.Variable"] =  Variable

function Variable:new(sort)
   local retval =  self:__new()
   retval.sort =  sort
   return retval
end

function Variable:get_sort()
   return self.sort
end

function Variable:get_name()
   return self.name
end

function Variable:set_name(name)
   self.name =  name
end

return Variable
