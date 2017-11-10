local Type =  require "base.type.aux.Type"

local VarAssgnm =  Type:__new()

package.loaded["logics.male.VarAssgnm"] =  VarAssgnm
local Dict =  require "base.type.Dict"

function VarAssgnm:new()
   local retval =  self:__new()
   retval.dict =  Dict:empty_dict_factory()
   return retval
end

function VarAssgnm:deref(var)
   return self.dict:deref(var)
end

function VarAssgnm:add(var, val)
   self.dict:add(var, val)
end

return VarAssgnm
