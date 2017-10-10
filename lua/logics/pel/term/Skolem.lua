local Term =  require "logics.pel.Term"

local Skolem =  Term:__new()

package.loaded["logics.pel.term.Skolem"] =  Skolem
local String =  require "base.type.String"

function Skolem:new(variable_spec, sort)
   local retval =  Term.new(self, variable_spec)
   retval.sort =  sort
   return retval
end

function Skolem:get_sort()
   return self.sort
end

function Skolem:get_base_term()
   if self.val
   then
      return self.val:get_base_term()
   end
end

function Skolem:set_base_term(term)
   self.val =  term
end

function Skolem:get_skolem()
   return self
end

function Skolem:get_substituted(substitution)
   local val =  self:get_base_term()
   if val
   then
      return val:get_substituted(substitution)
   end
end

function Skolem:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::pel::term::Skolem "))
   local base_term =  self:get_base_term()
   if base_term
   then
      base_term:__diagnose_single_line(indentation)
      indentation:insert(String:string_factory(": "))
   end
   indentation:insert(self:get_sort():get_name())
   indentation:insert(String:string_factory(")"))
end

function Skolem:__diagnose_multiple_line(indentation)
   local is_last_elem_multiple_line =  true
   indentation:insert(String:string_factory("(logics::pel::term::Skolem"))
   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   local base_term =  self:get_base_term()
   if base_term
   then
      is_last_elem_multiple_line =
         base_term:__diagnose_complex(indentation)
      deeper_indentation:insert(String:string_factory(": "))
   end
   deeper_indentation:insert(self:get_sort():get_name())
   deeper_indentation:save()
   indentation:insert(
         String:parenthesis_off_depending_factory(
               is_last_elem_multiple_line ))
end

return Skolem
