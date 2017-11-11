local Type =  require "base.type.aux.Type"

local Symbol =  Type:__new()

package.loaded["logics.qpel.Symbol"] =  Symbol
local QLCompoundExpression =  require "logics.ql.CompoundExpression"

function Symbol:new(pel_symbol, qualifier)
   local retval =  self:__new()
   retval.pel_symbol =  pel_symbol
   retval.ql =  QLCompoundExpression:new(pel_symbol, qualifier)
   return retval
end

function Symbol:get_pel_symbol()
   return self.pel_symbol
end

function Symbol:get_base_qualifier()
   return self:get_ql():get_base_qualifier()
end

function Symbol:get_ql()
   return self.ql
end

function Symbol:get_chopped_qualifier_copy(qualifier)
   local this_base, this_qualifier =  self:get_base_qualifier()
   local new_qual
      =  this_qualifier:get_rhs_chopped_copy(qualifier)
   return self:new(self:get_pel_symbol(), new_qual)
end

return Symbol
