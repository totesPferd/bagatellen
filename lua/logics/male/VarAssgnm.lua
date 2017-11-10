local Type =  require "base.type.aux.Type"

local VarAssgnm =  Type:__new()

package.loaded["logics.male.VarAssgnm"] =  VarAssgnm

function VarAssgnm:new()
   return VarAssgnm:__new()
end

return VarAssgnm
