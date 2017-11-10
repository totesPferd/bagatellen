local Type =  require "base.type.aux.Type"

local Symbol =  Type:__new()

package.loaded["logics.place.simple.Symbol"] =  Symbol

function Symbol:new()
   return self:__new()
end

function Symbol:is_system(system)
   if system == "simple"
   then
      return self
   end
end

return Symbol
