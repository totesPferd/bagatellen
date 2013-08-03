local Type =  require "base.type.aux.Type"

local Rule =  Type:__new()


package.loaded["logics.male.Rule"] =  Rule
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"

function Rule:new(goal)
   local retval =  Rule:__new()
   retval.goal =  goal
   return retval
end

function Rule:get_goal()
   return self.goal
end

function Rule:apply(proof_state)
end

function Rule:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics.male.Rule "))
   self:get_goal():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function Rule:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics.male.Rule"))
   local is_last_elem_multiple_line =  true
   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   is_last_elem_multiple_line =
      self:get_goal():__diagnose_complex(deeper_indentation)
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return Rule
