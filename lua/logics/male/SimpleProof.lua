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

function SimpleProof:_search_simply_start(simple_proof_state, goal)
   goal:set_settable_switch(false)
   for clause in self.action:elems()
   do local dev_clause =  clause:devar()
      if dev_clause:equate(goal)
      then
         simple_proof_state:use(dev_clause)
         return clause, dev_clause
      end
   end
end

function SimpleProof:apply(simple_proof_state, goal)
   local retval =  true
   local progress =  true
   local found_rule, found_rule_instance
      =  self:_search_simply_start(simple_proof_state, goal)
   if found_rule
   then
      self:drop(found_rule)
      local premis =  found_rule_instance:get_premis()
      if premis
      then
         retval =  self:apply(simple_proof_state, premis)
      end
      self:add(found_rule)
   else
      if simple_proof_state
      then
         simple_proof_state:add(goal)
      end
      retval =  false
      progress =  false
   end
   return retval, progress
end

function SimpleProof:add_rule(rule)
   local new_simple_proof =  self:copy()
   local premis =  rule:get_premis()
   if premis
   then
      local assume =  self:new_assume(premis)
      new_simple_proof:add(assume)
   end
   local conclusion =  rule:get_conclusion()
   local simple_proof_state =  self:new_simple_proof_state(conclusion)
   local status, progress =  self:apply(simple_proof_state, conclusion)
   simple_proof_state:push_to_simple_proof(self, premis)
   return progress
end

function SimpleProof:minimize()
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
