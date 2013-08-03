local Type =  require "base.type.aux.Type"

local ProofState =  Type:__new()


package.loaded["base.type.ProofState"] =  ProofState
local Indentation =  require "base.Indentation"
local Set =  require "base.type.Set"
local String =  require "base.type.String"

function ProofState:new(prs, clause)
   local retval =  ProofState:__new()
   retval.prs =  prs
   retval.premises =  clause:get_premises()
   retval.conclusions =  Set:empty_set_factory()
   retval.conclusions:add(clause:get_conclusion())
   return retval
end

function ProofState:get_prs()
   return self.prs
end

function ProofState:get_premises()
   return self.premises
end

function ProofState:get_conclusions()
   return self.conclusions
end

function ProofState:assume(goal)
   local retval =  self.get_premises():is_in(goal)
   if retval
   then
      self.get_conclusions():drop(goal)
   end
   return retval
end

function ProofState:resolve(key, substitution, goal)
   local axiom =  self.get_prs():deref(key):__clone()
   axiom:apply_substitution(substitution)
   local retval =  axiom:get_conclusion():__eq(goal)
   if retval
   then
      self.get_conclusions():drop(goal)
      self.get_conclusions():add_set(axiom:get_premises())
   end
   return retval
end

function ProofState:__clone()
   local retval =  ProofState:__new()
   retval.premises =  self:get_premises()
   retval.conclusions =  self:get_conclusions():__clone()
   retval.prs =  self:get_prs()
   return retval
end

function ProofState:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics.male.ProofState "))
   self:get_premises():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(" "))
   self:get_conclusions():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function ProofState:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics.male.ProofState"))
   local is_last_elem_multiple_line =  true

   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   is_last_elem_multiple_line =
      self:get_premises():__diagnose_complex(deeper_indentation)

   deeper_indentation:insert_newline()
   is_last_elem_multiple_line =
      self:get_conclusions():__diagnose_complex(deeper_indentation)

   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return ProofState
