local Type =  require "base.type.aux.Type"

local Interface =  Type:__new()

package.loaded["logics.place.simple.symbol.Interface"] =  Interface

function Interface:new()
   return self:__new()
end
