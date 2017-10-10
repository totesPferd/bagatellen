local Type =  require "base.type.aux.Type"

local Substitution =  Type:__new()

package.loaded["logics.pel.Substitution"] =  Substitution
local Dict =  require "base.type.Dict"
local Skolem =  require "logics.pel.term.Skolem"
local String =  require "base.type.String"

function Substitution:new(d0, d1)
   local retval =  self:__new()
   retval.d0 =  d0
   retval.d1 =  d1
   retval.s =  Dict:empty_dict_factory()
   return retval
end

function Substitution:get_d0()
   return self.d0
end

function Substitution:get_d1()
   return self.d1
end

function Substitution:deref(variable)
   return self.s:deref(variable)
end

function Substitution:complete()
   for variable in self:get_d1():get_variable_list():elems()
   do if not self.s:is_in_key_set(variable)
      then
         self.s:add(variable, Skolem:new(self:get_d0(), variable:get_sort()))
      end
   end
end

function Substitution:get_substituted(substitution)
   local new_d0 =  substitution:get_d0()
   local new_substitution =  Substitution:new(new_d0, self:get_d1())
   for variable, term in self.s:elems()
   do new_substitution:assign(
         variable
      ,  term:get_substituted(substitution) )
   end
   return new_subsitution
end

function Substitution:is_assigned(variable)
   return self.s:is_in_key_set(variable)
end

function Substitution:assign(variable, term)
   self.s:add(variable, term)
end

function Substitution:assign_once(variable, term)
   if self:is_assigned(variable)
   then
      local other_base_term =  term:get_base_term()
      local other_term_skolem =  term:get_skolem()
      local this_term =  self:deref(variable)
      local this_base_term =  this_term:get_base_term()
      local this_term_skolem =  this_term:get_skolem()
      if
                other_base_term
        and     this_base_term
      then
         return other_base_term == this_base_term
      elseif
                other_base_term
        and not this_base_term
        and     this_term_skolem
      then
         this_term_skolem:set_base_term(other_base_term)
         return true
      elseif
            not other_base_term
        and     other_term_skolem
        and     this_base_term
      then
         other_term_skolem:set_base_term(this_base_term)
         return true
      else
         return false
      end
   else
      self:assign(variable, term)
      return true
   end
end

function Substitution:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::pel::Substitution"))
   for variable, val in self.s:elems()
   do indentation:insert(String:string_factory(" "))
      indentation:insert(variable:get_non_nil_name())
      if val
      then
         indentation:insert(String:string_factory(":= "))
         val:__diagnose_single_line(indentation)
      end
      indentation:insert(String:string_factory(": "))
      indentation:insert(variable:get_sort():get_name())
   end
   indentation:insert(String:string_factory(")"))
end

function Substitution:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::pel::Substitution"))
   local is_last_elem_multiple_line =  true
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   for variable, val in self.s:elems()
   do deeper_indentation:insert_newline()
      deeper_indentation:insert(variable:get_non_nil_name())
      if val
      then
         deeper_indentation:insert(String:string_factory(":= "))
         is_last_elem_multiple_line =
            val:__diagnose_complex(deeper_indentation)
      end
      deeper_indentation:insert(String:string_factory(": "))
      deeper_indentation:insert(variable:get_sort():get_name())
   end
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return Substitution
