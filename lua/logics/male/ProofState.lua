local Type =  require "base.type.aux.Type"

local ProofState =  Type:__new()


package.loaded["logics.male.ProofState"] =  ProofState
local Indentation =  require "base.Indentation"
local ProofHistory =  require "logics.male.ProofHistory"
local Set =  require "base.type.Set"
local String =  require "base.type.String"

function ProofState:new(prs, clause)
   local retval =  ProofState:__new()
   retval.proof_history =  ProofHistory:new()
   retval.prs =  prs
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

function ProofState:applicable(goal)
   retval =  self.get_conclusions():is_in(goal)
   if retval
   then
      self.conclusions():drop(goal)
   end
   return retval
end

function ProofState:assume(goal)
   local retval =  self.get_premises():is_in(goal)
   if retval
   then
      retval =  self:applicable(goal)
   end
   return retval
end

function ProofState:resolve(key, substitution, goal, rec_stop)
   local axiom =  self.get_prs():deref(key):__clone()
   axiom:apply_substitution(substitution)
   local retval =
         axiom:get_conclusion():__eq(goal)
     and self:applicable(goal)
   if retval
   then
      local premises =  axiom:get_premises()
      if rec_stop
      then
         local keys =  self:get_proof_history():get_history():keys()
         local diff =  premises:__clone():cut_set(keys)
         retval =  diff:is_empty()
      end
      self.get_conclusions():add_set(premises)
   end
   return retval
end

function ProofState:apply_rule(rule, goal, rec_stop)
   local retval =  rule:apply(self, goal, rec_stop)
   if retval
   then
      self:get_proof_history():add(goal, rule)
   end
   return retval
end

function ProofState:apply_proof_history(proof_history)
   local retval =  true
   local history =  proof_history:get_history()
   local is_progress =  true
   while is_progress
   do is_progress =  false
      for goal in self:get_conclusions()
      do local rule =  history:deref(goal)
         if rule
         then
            local success =  self:apply_rule(rule, goal, true)
            is_progress =  success or is_progress
            retval =  retval and success
         end
      end
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
