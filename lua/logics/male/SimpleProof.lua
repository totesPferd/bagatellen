-- * `SimpleProof.deref` sollte als abstrakte Methode aufgefaßt werden.
--   In Logiken, in denen die Montanari-Unifikation mgus bestimmt,
--   kann die Klasse so angepaßt werden, daß sie genau eine solche
--   Unifikation vornimmt.
local Type =  require "base.type.aux.Type"

local SimpleProof =  Type:__new()


package.loaded["logics.male.SimpleProof"] =  SimpleProof
local Assume =  require "logics.male.simple_rule.Assume"
local Indentation =  require "base.Indentation"
local SimpleProofState =  require "logics.male.SimpleProofState"
local Set =  require "base.type.Set"
local String =  require "base.type.String"

function SimpleProof:new()
   local retval =  self:__new()
   retval.action =  Set:empty_set_factory()
   return retval
end

function SimpleProof:new_assume(literal)
   return Assume:new(literal)
end

function SimpleProof:new_simple_proof_state(conclusion)
   return SimpleProofState:new(conclusion)
end

function SimpleProof:add(simple_clause)
   self.action:add(simple_clause)
end

function SimpleProof:copy()
   retval =  self.__index:new()
   retval.action =  self.action:__clone()
   return retval
end

function SimpleProof:add_proof(other)
   self.action:add_set(other.action)
end

function SimpleProof:drop(simple_clause)
   self.action:drop(simple_clause)
end

function SimpleProof:search(goal)
   local action_list =  self.action:get_randomly_sorted_list()
   for simple_clause in action_list:elems()
   do local simple_clause_copy =  simple_clause:devar()
      if simple_clause_copy:equate(goal)
      then
         return simple_clause_copy
      end
   end
end

function SimpleProof:_search_simply_start(goal)
   for clause in self.action:elems()
   do local dev_clause =  clause:devar()
      if dev_clause:equate(goal)
      then
         return dev_clause
      end
   end
end

function SimpleProof:_search_simply_step(goal)
   for clause in self.action:elems()
   do if clause:get_conclusion() == goal
      then
         return clause
      end
   end
end

function Proof:_apply_step(proof_state, rule)
   local retval =  true
   self:drop(rule)
   local premis =  rule:get_premis()
   if premis
   then
      local new_rule =  self:_search_simply_step(premis)
      if new_rule
      then
         retval =  retval and self:_apply_step(proof_state, new_rule)
      else
         if proof_state
         then
            proof_state:add(premis)
         end
         retval =  false
      end
      if not proof_state and not retval
      then
         break
      end
   end
   self:add(rule)
   return retval
end

function SimpleProof:apply(proof_state, goal)
   local new_goal =  self:_search_simply_start(goal)
   if new_goal
   then
      return self:_apply_step(proof_state, new_goal)
   end
end

function SimpleProof:add_rule(rule)
   local new_proof =  self:copy()
   local premis =  rule:get_premis()
   if premis
   then
      local assume =  self:new_assume(premis)
      new_proof:add(assume)
   end
   local conclusion =  rule:get_conclusion()
   local simple_proof_state =  self:new_simple_proof_state(conclusion)
   self:apply(simple_proof_state, conclusion)
   simple_proof_state:push_to_proof(self, premis)
end

function SimpleProof:minimize()
   for rule in self.action:__clone():elems()
   do self:drop(rule)
      self:add_rule(rule)
   end
end

function SimpleProof:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::male::SimpleProof "))
   self.action:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function SimpleProof:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::male::SimpleProof"))
   local is_last_elem_multiple_line =  true

   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   is_last_elem_multiple_line =
      self.action:__diagnose_complex(deeper_indentation)
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return SimpleProof
