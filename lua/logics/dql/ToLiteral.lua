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
      indentation:insert(self:get_lhs_term():get_name())
      indentation:insert(String:string_factory(" "))
      indentation:insert(self:get_rhs_term():get_name())
   end
   indentation:insert(String:string_factory(")"))
end

function ToLiteral:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::dql::ToLiteral "))
   local is_last_elem_multiple_line =  true
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   do deeper_indentation:insert_newline()
      deeper_indentation:insert(self:get_lhs_term():get_name())
      deeper_indentation:insert_newline()
      deeper_indentation:insert(self:get_rhs_term():get_name())
   end
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return ToLiteral
