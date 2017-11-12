local Type =  require "base.type.aux.Type"

local Expression =  Type:__new()

package.loaded["logics.qpel.Expression"] =  Expression
local QLBase =  require "logics.qpel.qlBase.CompoundExpression"
local QLVariable =  require "logics.ql.Variable"

function Expression:new(pel_expression)
   local retval =  Expression:__new()
   retval.pel =  pel_expression
   do local var =  pel_expression:get_variable()
      if var
      then
         retval.ql =  QLVariable:new()
      else
         local compound_expression
            =  pel_expression:get_compound_expression()
         if compound_expression
         then
            retval.ql =  QLBase:new(compound_expression)
         end
      end
   end
   return retval
end

function Expression:get_pel()
   return self.pel
end

function Expression:get_ql()
   return self.ql
end

return Expression
