local Term =  require "logics.pel.Term"

local Literal =  Term:__new()

package.loaded["logics.pel.Literal"] =  Literal
local List =  require "base.type.List"
local String =  require "base.type.String"

function Literal:new(variable_context, pred, term_list)
   local retval =  Term.new(self, variable_context)
   retval.pred =  pred
   retval.term_list =  term_list
   return retval
end

function Literal:get_pred()
   return self.pred
end

function Literal:__diagnose_single_line(indentation)
   local p_name =  self:get_pred():get_name()
   indentation:insert(String:string_factory("(logics::pel::Literal "))
   indentation:insert(p_name)
   for term in self.term_list:elems()
   do indentation:insert(String:string_factory(" "))
      term:__diagnose_single_line(indentation)
   end
   indentation:insert(String:string_factory(")"))
end

function Literal:__diagnose_multiple_line(indentation)
   local p_name =  self:get_pred():get_name()
   indentation:insert(String:string_factory("(logics::pel::Literal "))
   indentation:insert(p_name)
   local is_last_elem_multiple_line =  true
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   for term in self.term_list:elems()
   do deeper_indentation:insert_newline()
      is_last_elem_multiple_line =
         term:__diagnose_complex(deeper_indentation)
   end
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return Literal
