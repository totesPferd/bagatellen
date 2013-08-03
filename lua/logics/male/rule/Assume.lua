local Rule =  require "logics.male.Rule"

local Assume =  Rule:__new()


package.loaded["logics.male.rule.Assume"] =  Assume
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"

function Assume:get_assume()
   return self
end

function Assume:apply(proof_state)
   return proof_state:assume(self:get_goal())
end

function Assume:__eq(other)
   local retval =  false
   local other_assume =  other.get_assume()
   if other_assume
   then
      retval =  Rule.__eq(self, other_assume)
   end
   return retval
end

function Assume:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics.male.Assume "))
   self:get_goal():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function Assume:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics.male.Assume"))
   local is_last_elem_multiple_line =  true
   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   is_last_elem_multiple_line =
      self:get_goal():__diagnose_complex(deeper_indentation)
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return Assume
