local Type =  require "base.type.aux.Type"

local CompoundExpression =  Type:__new()

package.loaded["logics.pel.CompoundExpression"] =  CompoundExpression
local List =  require "base.type.List"
local PELCompoundExpression =  require "logics.pel.CompoundExpression"
local QLBase =  require "logics.qpel.qlBase.CompoundExpression"
local QLCompoundExpression =  require "logics.ql.CompoundExpression"

function CompoundExpression:new(symbol, sub_term_list)
   local retval =  self:__new()

-- etwas fuer map/reduce...
   local pel_sub_term_list =  List:empty_list_factory()
   for sub_term in sub_term_list:elems()
   do pel_sub_term_list:append(sub_term:get_pel())
   end
   retval.pel =  PELCompoundExpression:new(
         symbol:get_pel()
      ,  pel_sub_term_list )

   retval.ql =  QLBase:new(self)

   return retval
end

function CompoundExpression:get_pel()
   return self.pel
end

function CompoundExpression:get_ql()
   return self.ql
end

return CompoundExpression
