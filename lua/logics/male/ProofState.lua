local Type =  require "base.type.aux.Type"

local ProofState =  Type:__new()


package.loaded["logics.male.ProofState"] =  ProofState
local Clause =  require "logics.male.Clause"
local Indentation =  require "base.Indentation"
local Set =  require "base.type.Set"
local String =  require "base.type.String"

function ProofState:new(proof_history, prs, clause)
   local retval =  ProofState:__new()
   retval.prs =  prs
   retval.proof_history =  proof_history
   retval.premises =  clause:get_premises()
   retval.conclusions =  Set:empty_set_factory()
   retval.conclusions:add(clause:get_conclusion())
   return retval
end

function ProofState:get_proof_history()
   return self.proof_history
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

function ProofState:is_proven()
   return self:get_conclusions():is_empty()
end

function ProofState:applicable(goal)
   retval =  self:get_conclusions():is_in(goal)
   if retval
   then
      self:get_conclusions():drop(goal)
   end
   return retval
end

function ProofState:derive_clause(goal)
   return Clause:new(self:get_premises(), goal)
end

function ProofState:derive_proof_state(goal)
   return ProofState:new(self:get_prs(), self:derive_clause(goal))
end

function ProofState:assume(goal)
   local retval =  self:get_premises():is_in(goal)
   if retval
   then
      retval =  self:applicable(goal)
      self:get_history():mark_as_proven(goal)
   end
   return retval
end

function ProofState:resolve(key, substitution, goal)
   local axiom =  self:get_prs():deref(key):__clone()
   axiom:apply_substitution(substitution)
   local retval =
         axiom:get_conclusion():__eq(goal)
     and self:applicable(goal)
   if retval
   then
      local is_empty =  true
      for premise in axiom:get_premises()
      do if self:get_history():is_proven(premise)
         then
            is_empty =  false
            self:get_conclusions():add(premise)
         end
      end
      if is_empty
      then
         self:get_history():mark_as_proven(goal)
      end
   end
   return retval
end

function ProofState:apply_rule(rule, goal)
   local retval =  rule:apply(self, goal)
   if retval
   then
      self:get_proof_history():add(goal, rule)
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
