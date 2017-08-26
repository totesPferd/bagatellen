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
   local retval =  Proof:__new()
   retval.action =  Set:empty_set_factory()
   retval.prs =  prs
   return retval
end

function Proof:get_prs()
   return self.prs
end

-- can be used as abstract method
function Proof:subsumes(goal, conclusion)
   return goal == conclusion
end

function Proof:deref(goal)
   for resolve in self.action:elems()
   do if self:subsumes(goal, resolve:get_conclusion(self:get_prs()))
      then
         return resolve
      end
   end
end

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

function Proof:tell_proven_goals(other)
   for resolve in self.action:elems()
   do other:add(resolve)
   end
end

function Proof:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics.male.Proof "))
   self.action:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function Proof:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics.male.Proof"))
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
