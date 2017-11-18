local QLToLiteral =  require "logics.ql.ToLiteral"

local ToLiteral =  QLToLiteral:__new()

package.loaded["logics.dql.ToLiteral"] =  ToLiteral
local String =  require "base.type.String"

function ToLiteral:new(lhs_term, rhs_term)
   return QLToLiteral.new(self, lhs_term, rhs_term)
end

function ToLiteral:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::dql::ToLiteral "))
   do indentation:insert(String:string_factory(" "))
      self:get_lhs_term():__diagnose_single_line(indentation)
      indentation:insert(String:string_factory(" "))
      self:get_rhs_term():__diagnose_single_line(indentation)
   end
   indentation:insert(String:string_factory(")"))
end

function ToLiteral:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::dql::ToLiteral "))
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

return ToLiteral
