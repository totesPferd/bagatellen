local QPELSymbol =  require "logics.qpel.Symbol"

local Symbol =  QPELSymbol:__new()

package.loaded["logics.dqpel.Symbol"] =  Symbol
local String =  require "base.type.String"

function Symbol:new(name, qualifier)
   return QPELSymbol.new(self, name, qualifier)
end

function Symbol:get_name()
   local this_base, this_qualifier =  self:get_base_qualifier()
   local retval =  this_base:__clone()
   retval:append_string(String:string_factory("."))
   retval:append_string(this_qualifier:get_name())
   return retval
end

return Symbol
