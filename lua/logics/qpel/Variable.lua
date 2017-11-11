local Type =  require "base.type.aux.Type"

local Variable =  Type:__new()

package.loaded["logics.qpel.Variable"] =  Variable
local PELVariable =  require "logics.pel.Variable"
local QLVariable =  require "logics.ql.Variable"

function Variable:new()
   local retval =  self:__new()
   retval.pel =  PELVariable:new()
   retval.ql =  QLVariable:new()
   return retval
end

function Variable:get_pel()
   return self.pel
end

function Variable:get_ql()
   return self.ql
end

return Variable
