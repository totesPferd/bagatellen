local Type =  require "base.type.aux.Type"

local Proof =  Type:__new()


package.loaded["logics.male.Proof"] =  Proof
local Dict =  require "base.type.Dict"
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"

function Proof:new()
   local retval =  Proof:__new()
   retval.history =  Dict:empty_dict_factory()
   return retval
end

function Proof:deref(goal)
   return self.history:deref(goal)
end

function Proof:keys()
   return self.history:keys()
end

function Proof:add(goal, rule)
   self.history:add(goal, rule)
end

function Proof:drop_all_assumes()
   for goal in self:keys()
   do local rule =  self.history:deref(goal)
      self.history:drop(goal)
   end
end

function Proof:tell_proven_goals(other)
   for goal in self.history:get_keys()
   do local rule =  self.history:deref(goal)
      other:add(goal, rule)
   end
end

function Proof:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics.male.Proof "))
   self.history:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function Proof:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics.male.Proof"))
   local is_last_elem_multiple_line =  true

   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   is_last_elem_multiple_line =
      self.history:__diagnose_complex(deeper_indentation)
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return Proof
