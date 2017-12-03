-- * `Proof.deref` sollte als abstrakte Methode aufgefaßt werden.
--   In Logiken, in denen die Montanari-Unifikation mgus bestimmt,
--   kann die Klasse so angepaßt werden, daß sie genau eine solche
--   Unifikation vornimmt.
local Type =  require "base.type.aux.Type"

local Proof =  Type:__new()


package.loaded["logics.male.Proof"] =  Proof
local Assume =  require "logics.male.rule.Assume"
local Indentation =  require "base.Indentation"
local ProofState =  require "logics.male.ProofState"
local Set =  require "base.type.Set"
local String =  require "base.type.String"

function Proof:new()
   local retval =  self:__new()
   retval.action =  Set:empty_set_factory()
   return retval
end

function Proof:new_assume(literal)
   return Assume:new(literal)
end

function Proof:new_proof_state(conclusions)
   return ProofState:new(conclusions)
end

function Proof:copy()
   retval =  self.__index:new()
   retval.action =  self.action:__clone()
   return retval
end

function Proof:add(clause)
   self.action:add(clause)
end

function Proof:add_proof(other)
   self.action:add_set(other.action)
end

function Proof:drop(clause)
   self.action:drop(clause)
end

function Proof:_search_simply_start(proof_state, goal)
   goal:set_unsettable()
   for clause in self.action:elems()
   do local dev_clause =  clause:devar()
      if dev_clause:equate(goal)
      then
         proof_state:use(dev_clause)
         return clause, dev_clause
      end
   end
end

function Proof:apply(proof_state, goal)
   local retval =  true
   local progress =  true
   local found_rule, found_rule_instance
      =  self:_search_simply_start(proof_state, goal)
   if found_rule
   then
      self:drop(found_rule)
      for premis in found_rule_instance:get_premises():elems()
      do retval =  self:apply(proof_state, premis)
         if not proof_state and not retval
         then
            break
         end
      end
      self:add(found_rule)
   else
      if proof_state
      then
         proof_state:add(goal)
      end
      retval =  false
      progress =  false
   end
   return retval, progress
end

function Proof:add_rule(rule)
   local new_proof =  self:copy()
   local premises =  rule:get_premises()
   for premis in premises:elems()
   do local assume =  self:new_assume(premis)
      new_proof:add(assume)
   end
   local conclusion =  rule:get_conclusion()
   local conclusions =  Set:empty_set_factory()
   conclusions:add(conclusion)
   local proof_state =  self:new_proof_state(conclusions)
   local status, progress =  self:apply(proof_state, conclusion)
   proof_state:push_to_proof(self, premises)
   return progress
end

function Proof:minimize()
   local rep =  true
   while rep
   do rep =  false
      for rule in self.action:__clone():elems()
      do self:drop(rule)
         local progress =  self:add_rule(rule)
         if progress
         then
            rep =  true
         end
      end
   end
end

function Proof:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::male::Proof "))
   self.action:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function Proof:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::male::Proof"))
   local is_last_elem_multiple_line =  true

   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   is_last_elem_multiple_line =
      self.action:__diagnose_complex(deeper_indentation)
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return Proof
