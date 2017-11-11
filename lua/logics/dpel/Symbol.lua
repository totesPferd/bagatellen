local Type =  require "base.type.aux.Type"

local Symbol =  Type:__new()

package.loaded["logics.dpel.Symbol"] =  Symbol

function Symbol:new(name)
   local retval =  Symbol:__new()
   retval.name =  name
   return retval
end

function Symbol:get_name()
   return self.name
end

return Symbol
