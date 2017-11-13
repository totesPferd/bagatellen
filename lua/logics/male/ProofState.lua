local Type =  require "base.type.aux.Type"

local ProofState =  Type:__new()


package.loaded["logics.male.ProofState"] =  ProofState
local Clause =  require "logics.male.Clause"
local Indentation =  require "base.Indentation"
local Set =  require "base.type.Set"
local String =  require "base.type.String"
local VarAssgnm =  require "logics.male.VarAssgnm"

function ProofState:new(clause)
   local retval =  self:__new()
   retval.premises =  clause:get_premises()
   retval.conclusions =  Set:empty_set_factory()
   retval.conclusions:add(clause:get_conclusion())
   for goal in retval.premises
   do retval:assume(goal)
   end
   return retval
end

function ProofState:new_var_assgnm()
   return VarAssgnm:new()
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

function ProofState:assume(goal)
   local retval =  self:get_premises():is_in(goal)
   if retval
   then
      self:get_conclusions():drop(goal)
   end
   return retval
end

function ProofState:resolve(axiom, goal)
   local retval =  axiom:equate(goal)
   if retval
   then
      self:get_conclusions():drop(goal)
      for premise in axiom:get_premises()
      do self:get_conclusions():add(premise)
      end
   end
   return retval
end

function ProofState:apply_rule(rule, goal)
   local retval =  rule:apply(self, goal)
   return retval
end


function ProofState:apply_proof(proof)
   local rep =  true
   while rep
   do rep =  false
      local conclusions =  self:get_devared_conclusions()
      for conclusion in conclusions:elems()
      do local clause =  proof:search(conclusion)
         if clause
         then
            rep =  true
            self:get_conclusions():drop(goal)
            for premise in axiom:get_premises()
            do self:get_conclusions():add(premise)
            end
         end
      end
   end
end

function ProofState:get_devared_premises(var_assgnm)
   local retval =  Set:empty_set_factory()
   for premis in self:get_premises()
   do retval:add(premis:devar(var_assgnm))
   end
   return retval
end

function ProofState:get_devared_conclusions(var_assgnm)
   local retval =  Set:empty_set_factory()
   for conclusion in self:get_conclusions()
   do retval:add(conclusion:devar(var_assgnm))
   end
   return retval
end

function ProofState:devar()
   local var_assgnm =  self:new_var_assgnm()
   local retval =  self:__new()
   retval.premises =  self:get_devared_premises(var_assgnm)
   retval.conclusions =  self:get_devared_conclusions(var_assgnm)
   return retval
end

function ProofState:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::male::ProofState "))
   self:get_premises():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(" "))
   self:get_conclusions():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function ProofState:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::male::ProofState"))
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
