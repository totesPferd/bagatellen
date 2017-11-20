local Type =  require "base.type.aux.Type"

local ToLiteral =  Type:__new()

package.loaded["logics.ql.ToLiteral"] =  ToLiteral

function ToLiteral:new(lhs_term, rhs_term)
   local retval =  self:__new()
   retval.lhs_term =  lhs_term
   retval.rhs_term =  rhs_term
   return retval
end

function ToLiteral:new_instance(lhs_term, rhs_term)
   return self.__index:new(lhs_term, rhs_term)
end

function ToLiteral:get_lhs_term()
   return self.lhs_term
end

function ToLiteral:get_rhs_term()
   return self.rhs_term
end

function ToLiteral:get_to_literal()
   return self
end

function ToLiteral:equate(other)
   local retval =  false
   local other_to_literal =  other:get_to_literal()
   if other_to_literal
   then
      retval =  self:get_lhs_term():equate(other_to_literal:get_lhs_term())
      if retval
      then
         retval =  self:get_rhs_term():equate(other_to_literal:get_rhs_term())
      end
   end
   return retval
end

function ToLiteral:devar(var_assgnm)
   local new_lhs_term =  self:get_lhs_term():devar(var_assgnm)
   local new_rhs_term =  self:get_rhs_term():devar(var_assgnm)
   return self:new_instance(new_lhs_term, new_rhs_term)
end

function ToLiteral:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::ql::ToLiteral "))
   do indentation:insert(String:string_factory(" "))
      indentation:insert(self:get_lhs_term():get_name())
      indentation:insert(String:string_factory(" "))
      indentation:insert(self:get_rhs_term():get_name())
   end
   indentation:insert(String:string_factory(")"))
end

function ToLiteral:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::ql::ToLiteral "))
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
