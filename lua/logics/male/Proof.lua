-- * `Proof`-Objekte enthalten derzeit ein dict (`actions`)
--   In Zukunft sollten `Proof`-Objekte Mengen von `Rule`s enthalten.
-- * `Proof.deref` sollte als abstrakte Methode aufgefaßt werden.
--   In Logiken, in denen die Montanari-Unifikation mgus bestimmt,
--   kann die Klasse so angepaßt werden, daß sie genau eine solche
--   Unifikation vornimmt.
local Type =  require "base.type.aux.Type"

local Proof =  Type:__new()


package.loaded["logics.male.Proof"] =  Proof
local Dict =  require "base.type.Dict"
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"

function Proof:new()
   local retval =  Proof:__new()
   retval.action =  Dict:empty_dict_factory()
   return retval
end

-- can be used as abstract method
function Proof:deref(goal)
   return self.action:deref(goal)
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
   return self.action:keys()
end

function Proof:add(goal, rule)
   self.action:add(goal, rule)
end

function Proof:get_blind_goal_set(prs)
   local retval =  Set:empty_set_factory()
   for goal in self:keys()
   do local rule =  self.action:deref(goal)
      retval:add_set(rule:get_blind_goal_set(prs, self))
   end
   return retval
end

function Proof:drop_all_assumes()
   for goal in self:keys()
   do local rule =  self.action:deref(goal)
      local assume =  rule:get_assume()
      if assume
      then
         self.action:drop(goal)
      end
   end
end

function Proof:drop_all_blinds(prs)
   local is_active =  true
   while is_active
   do local a_c =  self.action:__clone()
      is_active =  false
      for goal, rule in a_c:elems()
      do if rule:is_blind(prs, self)
         then
            self.action:drop(goal)
            is_active =  true
         end
      end
   end
end
      
function Proof:tell_proven_goals(other)
   for goal in self.action:get_keys()
   do local rule =  self.action:deref(goal)
      other:add(goal, rule)
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
