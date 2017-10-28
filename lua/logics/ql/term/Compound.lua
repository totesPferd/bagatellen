local Term =  require "logics.ql.Term"

local Compound =  Term:__new()

package.loaded["logics.ql.term.Compound"] =  Compound
local String =  require "base.type.String"

function Compound:new(base_spec, qualifier)
   local retval =  Term.new(self, base_spec:get_variable_spec())
   retval.base_spec =  base_spec
   retval.qualifier =  qualifier
   return retval
end

function Compound:get_base_spec()
   return self.base_spec
end

function Compound:get_qualifier()
   return self.qualifier
end

function Compound:get_compound()
   return self
end

function Compound:get_qualified(qualifier)
  local new_qual =  self:get_qualifier():__clone()
  new_qual:append_qualifier(qualifier)
  return Compound:new(self:get_base_spec(), new_qual)
end

function Compound:get_substituted(substitution)
   return self:get_base_spec():get_substituted(substitution):get_qualified(self:get_qualifier())
end

function Compound:__eq(other)
   local other_compound =  other:get_compound()
   if other_compound
   then
      return
            self:get_base_spec() == other:get_base_spec()
        and self:get_qualifier() == other:get_qualifier()
   else
      return false
   end
end

function Compound:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::ql::Compound "))
   indentation:insert(self:get_qualifier():get_name())
   indentation:insert(String:string_factory(" "))
   self:get_base_spec():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function Compound:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::ql::Compound"))
   local is_last_elem_multiple_line =  true
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   deeper_indentation:insert_newline()
   deeper_indentation:insert(self:get_qualifier():get_name())
   is_last_elem_multiple_line =
      self:get_base_spec():__diagnose_complex(deeper_indentation)
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return Compound
