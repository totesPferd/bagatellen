local Type =  require "base.type.aux.Type"

local QLBase =  Type:__new()

package.loaded["logics.qpel.qlBase.CompoundExpression"] =  QLBase
local Expression =  require "logics.qpel.Expression"
local List =  require "base.type.List"
local PELCompoundExpression =  require "logics.pel.CompoundExpression"

function QLBase:new(compound_expression)
   local retval =  self:__new()
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
   local ret_base
   local pel_compound_expression =  self:get_base_compound_expression()
   local pel_compound_expression_symbol
      =  pel_compound_expression:get_symbol()
   local ret_qualifier =  pel_compound_expression_symbol:get_qualifier()

   for sub_term in self:get_sub_term_list():elems()
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

   if ret_qualifier.is_id()
   then
      ret_base =  self
   else
      local new_symbol
         =  pel_compound_expression_symbol:get_chopped_qualifier_copy(
               ret_qualifier )
-- good for map/reduce et al.
      local new_sub_term_list =  List:empty_list_factory()
      for sub_term in self:get_sub_term_list():elems()
      do new_sub_term_list:append(
               sub_term:get_chopped_qualifier_copy(ret_qualifier) )
      end
      ret_base =  self:new(
            self:new_pel_compound_expression(new_symbol, new_sub_term_list) )
   end

   return ret_base, ret_qualifier
end

return QLBase
