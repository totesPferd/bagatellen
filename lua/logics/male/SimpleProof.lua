-- * `SimpleProof.deref` sollte als abstrakte Methode aufgefaßt werden.
--   In Logiken, in denen die Montanari-Unifikation mgus bestimmt,
--   kann die Klasse so angepaßt werden, daß sie genau eine solche
--   Unifikation vornimmt.
local Type =  require "base.type.aux.Type"

local SimpleProof =  Type:__new()


package.loaded["logics.male.SimpleProof"] =  SimpleProof
local Set =  require "base.type.Set"
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"

function SimpleProof:new()
   local retval =  self:__new()
   retval.action =  Set:empty_set_factory()
   return retval
end

function SimpleProof:add(simple_clause)
   self.action:add(simple_clause)
end

function SimpleProof:copy()
   retval =  self.__index:new()
   retval.action =  self.action
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

function SimpleProof:search_simply(goal)
   for simple_clause in self.action
   do local simple_clause_copy =  simple_clause:devar()
      if simple_clause_copy:equate(goal)
      then
         return simple_clause_copy
      end
   end
end

function SimpleProof:apply(simple_proof_state, goal)
   local retval
   local rule_found =  self:search_simply(goal)
   if rule_found
   then
      retval =  true
      self:drop(goal)
      local premis =  rule_found:get_premis()
      if premis
      then
         retval =  self:apply(simple_proof_state, premis)
      end
      self:add(goal)
   else
      if simple_proof_state
      then
         simple_proof_state:add(goal)
      end
      retval =  false
   end
   return retval
end

function SimpleProof:minimize()
   for rule in self.action:elems()
   do self:drop(rule)
      if not self:apply(nil, rule)
      then
         self:add(rule)
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
