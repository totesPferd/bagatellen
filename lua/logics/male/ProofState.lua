local Type =  require "base.type.aux.Type"

local ProofState =  Type:__new()


package.loaded["logics.male.ProofState"] =  ProofState
local Indentation =  require "base.Indentation"
local Set =  require "base.type.Set"
local String =  require "base.type.String"
local VarAssgnm =  require "logics.male.VarAssgnm"

function ProofState:new(conclusions)
   local retval =  self:__new()
   retval.conclusions =  conclusions
   return retval
end

function ProofState:new_instance(conclusions)
   return ProofState:new(conclusions)
end

function ProofState:new_var_assgnm()
   return VarAssgnm:new()
end

function ProofState:get_conclusions()
   return self.conclusions
end

function ProofState:is_proven()
   return self:get_conclusions():is_empty()
end

function ProofState:resolve(axiom, goal)
   local retval =  axiom:equate(goal)
   if retval
   then
      self:get_conclusions():drop(goal)
      for premise in axiom:get_premises():elems()
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
      local conclusions =  self:get_conclusions()
      local conclusions_list =  conclusions:get_randomly_sorted_list()
      for conclusion in conclusions_list:elems()
      do local clause =  proof:search(conclusion)
         if clause
         then
            rep =  rep or self:resolve(clause, conclusion)
         end
      end
   end
end

function ProofState:apply_proof_simply(proof)
   local rep =  true
   while rep
   do rep =  false
      for conclusion in self:get_conclusions():elems()
      do local clause =  proof:search_simply(conclusion)
         if clause
         then
            rep =  self:resolve(clause, conclusion)
         end
      end
   end
end

function ProofState:get_devared_conclusions(var_assgnm)
   local retval =  Set:empty_set_factory()
   for conclusion in self:get_conclusions():elems()
   do retval:add(conclusion:devar(var_assgnm))
   end
   return retval
end

function ProofState:devar()
   local var_assgnm =  self:new_var_assgnm()
   local new_conclusions =  self:get_devared_conclusions(var_assgnm)
   return self:new_instance(new_conclusions)
end

function ProofState:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::male::ProofState "))
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
      self:get_conclusions():__diagnose_complex(deeper_indentation)

   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return ProofState
