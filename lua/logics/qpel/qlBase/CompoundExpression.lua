local QLCompoundExpression =  require "logics.ql.CompoundExpression"

local QLBase =  QLCompoundExpression:__new()

package.loaded["logics.qpel.qlBase.CompoundExpression"] =  QLBase
local Expression =  require "logics.qpel.Expression"
local List =  require "base.type.List"
local PELCompoundExpression =  require "logics.pel.CompoundExpression"
local VarAssgnm =  require "logics.male.VarAssgnm"

function QLBase:new(base, qualifier)
end

function QLBase:new(compound_expression)
   local retval =  QLCompoundExpression.__new(self)
   retval.compound_expression =  compound_expression
   return retval
end

function QLBase:new_pel_compound_expression(symbol, sub_term_list)
   PELCompoundExpression:new(symbol, sub_term_list)
end

function QLBase:get_base_compound_expression()
   return self.compound_expression
end

function QLBase:get_variable()
end

function QLBase:get_compound_expression()
   return self
end

function QLBase:get_base_qualifier()
   local pel_compound_expression =  self:get_base_compound_expression()
   local pel_compound_expression_symbol
      =  pel_compound_expression:get_symbol()
   local ret_base, ret_qualifier
      =  pel_compound_expression_symbol:get_base_qualifier()

   for sub_term in pel_compound_expression:get_sub_term_list():elems()
   do local qpel_sub_term =  Expression:new(sub_term)
      local ql_sub_term =  qpel_sub_term:get_ql()
      local sub_term_base, sub_term_qualifier
         =  ql_sub_term:get_base_qualifier()
      local ret_qualifier =
            ret_qualifier:get_longest_common_tail(
                  sub_term_qualifier )
      if ret_qualifier:is_id()
      then
         break
      end
   end

   if ret_qualifier:is_id()
   then
      ret_base =  self
   else
      local var_assgnm =  VarAssgnm:new()
      ret_base
         =  pel_compound_expression:get_chopped_qualifier_copy(
               var_assgnm
            ,  ret_qualifier )
   end

   return ret_base, ret_qualifier
end

return QLBase
