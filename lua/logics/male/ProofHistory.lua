local Type =  require "base.type.aux.Type"

local ProofHistory =  Type:__new()


package.loaded["logics.male.ProofHistory"] =  ProofHistory
local Dict =  require "base.type.Dict"
local Indentation =  require "base.Indentation"
local Set =  require "base.type.Set"
local String =  require "base.type.String"

function ProofHistory:new()
   local retval =  ProofHistory:__new()
   retval.history =  Dict:empty_dict_factory()
   retval.proven_goals =  Set:empty_set_factory()
   return retval
end

function ProofHistory:deref(goal)
   return self.history:deref(goal)
end

function ProofHistory:add(goal, rule)
   self.history:add(goal, rule)
end

function ProofHistory:is_proven(goal)
   return self.proven_goals:is_in(goal)
end

function ProofHistory:mark_as_proven(goal)
   return self.proven_goals:add(goal)
end

function ProofHistory:drop_all_assumes()
   for goal in self.history:keys()
   do local rule =  self.history:deref(goal)
      self.history:drop(goal)
      self.proven_goals:drop(goal)
   end
end

function ProofHistory:mark_all_as_unproven()
   self.proven_goals =  Set:empty_set_factory()
end

function ProofHistory:tell_proven_goals(other)
   for goal in self.history:get_keys()
   do local rule =  self.history:deref(goal)
      other:add(goal, rule)
      other:mark_as_proven(goal)
   end
end

function ProofHistory:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics.male.ProofHistory "))
   self.history:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(" "))
   self.proven_goals:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function ProofHistory:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics.male.ProofHistory"))
   local is_last_elem_multiple_line =  true

   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   is_last_elem_multiple_line =
      self.history:__diagnose_complex(deeper_indentation)
   deeper_indentation:insert_newline()
   is_last_elem_multiple_line =
      self.proven_goals:__diagnose_complex(deeper_indentation)
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return ProofHistory
