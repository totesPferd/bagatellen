local Term =  require "logics.ql.Term"

local Literal =  Term:__new()

package.loaded["logics.ql.Literal"] =  Literal
local List =  require "base.type.List"
local String =  require "base.type.String"

function Literal:new(variable_spec, pred, term_list)
   local retval =  Term.new(self, variable_spec)
   retval.pred =  pred
   retval.term_list =  term_list
   return retval
end

function Literal:get_pred()
   return self.pred
end

function Literal:get_substituted(substitution)
   local variable_spec =  substitution:get_d0(substitution)
   local res_term_list =  List:empty_list_factory()
   for term in self.term_list:elems()
   do res_term_list:append(term:get_substituted(substitution))
   end
   return Literal:new(variable_spec, self:get_pred(), res_term_list)
end

function Literal:get_unifier(other)
   if self:get_pred() == other:get_pred()
   then
      local substitution =  Substitution(other:get_d0(), self:get_d0())
      local keep_looping =  true
      local other_term_list =  other:get_term_list():__clone()
      for sub_term in self:get_term_list():elems()
      do keep_looping =  sub_term:_aux_unif(
            substitution
         ,  other_term_list:get_head() )
         if keep_looping
         then
            other_term_list:cut_head()
         else
            break
         end
      end
      if keep_looping
      then
         substitution:complete()
         return substitution
      end
   end
end

function Literal:__diagnose_single_line(indentation)
   local p_name =  self:get_pred():get_name()
   indentation:insert(String:string_factory("(logics::ql::Literal "))
   indentation:insert(p_name)
   for term in self.term_list:elems()
   do indentation:insert(String:string_factory(" "))
      term:__diagnose_single_line(indentation)
   end
   indentation:insert(String:string_factory(")"))
end

function Literal:__diagnose_multiple_line(indentation)
   local p_name =  self:get_pred():get_name()
   indentation:insert(String:string_factory("(logics::ql::Literal "))
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
