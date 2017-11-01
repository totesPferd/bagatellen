local Term =  require "logics.pel.Term"

local Compound =  Term:__new()

package.loaded["logics.pel.term.Compound"] =  Compound
local List =  require "base.type.List"
local String =  require "base.type.String"

function Compound:new(variable_context, fun, term_list)
   local retval =  Term.new(self, variable_context)
   retval.fun =  fun
   retval.term_list =  term_list
   return retval
end

function Compound:get_fun()
   return self.fun
end

function Compound:get_sort()
   return self:get_fun():get_sort()
end

function Compound:get_compound()
   return self
end

function Compound:__eq(other)
   local other_compound =  other:get_compound()
   if other_compound
   then
     return
         self:get_fun() == other:get_fun()
     and self:get_term_list() == other:get_term_list()
   else
      return false
   end
end

function Compound:__diagnose_single_line(indentation)
   local f_name =  self:get_fun():get_name()
   indentation:insert(String:string_factory("(logics::pel::term::Compound "))
   indentation:insert(f_name)
   for term in self.term_list:elems()
   do indentation:insert(String:string_factory(" "))
      term:__diagnose_single_line(indentation)
   end
   indentation:insert(String:string_factory(")"))
end

function Compound:__diagnose_multiple_line(indentation)
   local f_name =  self:get_fun():get_name()
   indentation:insert(String:string_factory("(logics::pel::term::Compound "))
   indentation:insert(f_name)
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

return Compound
