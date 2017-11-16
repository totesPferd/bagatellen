local QLEqLiteral =  require "logics.ql.EqLiteral"

local EqLiteral =  QLEqLiteral:__new()

package.loaded["logics.dql.EqLiteral"] =  EqLiteral
local String =  require "base.type.String"

function EqLiteral:new(lhs_term, rhs_term)
   return QLEqLiteral.new(self, lhs_term, rhs_term)
end

function EqLiteral:new_instance(lhs_term, rhs_term)
   return EqLiteral:new(lhs_term, rhs_term)
end

function EqLiteral:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::dql::EqLiteral "))
   do indentation:insert(String:string_factory(" "))
      self:get_lhs_term():__diagnose_single_line(indentation)
      indentation:insert(String:string_factory(" "))
      self:get_rhs_term():__diagnose_single_line(indentation)
   end
   indentation:insert(String:string_factory(")"))
end

function EqLiteral:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::dql::EqLiteral "))
   local is_last_elem_multiple_line =  true
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   do deeper_indentation:insert_newline()
      self:get_lhs_term():__diagnose_complex(deeper_indentation)
      deeper_indentation:insert_newline()
      is_last_elem_multiple_line =
         self:get_rhs_term():__diagnose_complex(deeper_indentation)
   end
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return EqLiteral
