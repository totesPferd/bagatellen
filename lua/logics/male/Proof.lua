-- * `Proof.deref` sollte als abstrakte Methode aufgefaßt werden.
--   In Logiken, in denen die Montanari-Unifikation mgus bestimmt,
--   kann die Klasse so angepaßt werden, daß sie genau eine solche
--   Unifikation vornimmt.
local Type =  require "base.type.aux.Type"

local Proof =  Type:__new()


package.loaded["logics.male.Proof"] =  Proof
local Set =  require "base.type.Set"
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"

function Proof:new(prs)
   local retval =  self:__new()
   retval.action =  Set:empty_set_factory()
   retval.prs =  prs
   return retval
end

function Proof:get_prs()
   return self.prs
end

-- can be used as abstract method
function Proof:deref(goal)
   for resolve in self.action:elems()
   do if goal == resolve:get_conclusion(self:get_prs())
      then
         return resolve
      end
   end
end

-- Graph theoretic functions.
function Proof:is_containing_sink(premis)
   local goals =  self:get_all_sources(premis)
   if goals:is_empty()
   then
      return false
   else
      return true
   end
end
   
function Proof:is_containing_source(goal)
   local resolve =  self:deref(goal)
   if resolve
   then
      return true
   else
      return false
   end
end

function Proof:is_containing_node(clause)
   return self:is_containing_source(clause)
      or  self:is_containing_sink(clause)
end

function Proof:is_containing_edge(goal, premis)
   local resolve =  self:deref(goal)
   if resolve
   then
      return self:get_all_sinks(goal):is_in(premis)
   else
      return false
   end
end

function Proof:get_all_sinks(goal)
   local resolve =  self:deref(goal)
   if resolve
   then
      local axiom =  resolve:get_axiom(self:get_prs())
      return axiom:get_premises()
   end
end

function Proof:get_all_sources(premis)
   local retval =  Set:empty_set_factory()
   for goal in self.action:elems()
   do if self:is_containing_edge(goal, premis)
      then
         retval:add(goal)
      end
   end
   return retval
end

function Proof:get_all_nodes()
   local retval =  Set:empty_set_factory()
   for resolve in self.action:elems()
   do local axiom =  resolve:get_axiom(self:get_prs())
      retval:add(axiom:get_conclusion())
      retval:add_set(axiom:get_premises())
   end
end
--- end of graph theoretic functions.

function Proof:is_containing(goals)
   for goal in goals:elems()
   do if not(self:deref(goal))
      then
         return false
      end
   end
   return true
end

function Proof:keys()
   retval =  Set:empty_set_factory()
   for resolve in self.action:elems()
   do retval:add(resolve:get_conclusion(self:get_prs()))
   end
   return retval
end

function Proof:add(resolve)
   self.action:add(resolve)
end

function Proof:add_proof(other)
   self.action:add_set(other.action)
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
