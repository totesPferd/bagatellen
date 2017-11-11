local QPELCompoundExpression =  require "logics.qpel.CompoundExpression"

local CompoundExpression =  QPELCompoundExpression:__new()

package.loaded["logics.dqpel.CompoundExpression"] =  CompoundExpression
local String =  require "base.type.String"

function CompoundExpression:new(symbol, sub_term_list)
   return QPELCompoundExpression.new(self, symbol, sub_term_list)
end

function CompoundExpression:__diagnose_single_line(indentation)
   local f_name =  self:get_pel():get_symbol():get_name()
   indentation:insert(String:string_factory("(logics::dqpel::CompoundExpression "))
   indentation:insert(f_name)
   for term in self:get_sub_term_list():elems()
   do indentation:insert(String:string_factory(" "))
      term:__diagnose_single_line(indentation)
   end
   indentation:insert(String:string_factory(")"))
end

function CompoundExpression:__diagnose_multiple_line(indentation)
   local f_name =  self:get_pel():get_symbol():get_name()
   indentation:insert(String:string_factory("(logics::dqpel::CompoundExpression "))
   indentation:insert(f_name)
   local is_last_elem_multiple_line =  true
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   for term in self:get_sub_term_list():elems()
   do deeper_indentation:insert_newline()
      is_last_elem_multiple_line =
         term:__diagnose_complex(deeper_indentation)
   end
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return CompoundExpression
