local Type =  require "base.type.aux.Type"

local SimpleProofState =  Type:__new()


package.loaded["logics.male.SimpleProofState"] =  SimpleProofState
local Indentation =  require "base.Indentation"
local Set =  require "base.type.Set"
local String =  require "base.type.String"
local VarAssgnm =  require "logics.male.VarAssgnm"

function SimpleProofState:new(conclusion)
   local retval =  self:__new()
   retval.conclusion =  conclusion
   return retval
end

function SimpleProofState:new_instance(conclusion)
   return SimpleProofState:new(conclusion)
end

function SimpleProofState:new_var_assgnm()
   return VarAssgnm:new()
end

function SimpleProofState:get_conclusion()
   return self.conclusion
end

function SimpleProofState:set_conclusion(conclusion)
   self.conclusion =  conclusion
end

function SimpleProofState:is_proven()
   return not self:get_conclusion()
end

function SimpleProofState:resolve(premis, conclusion, goal)
   local retval =  conclusion:equate(goal)
   if retval
   then
      self:set_conclusion(premis)
   end
   return retval
end

function SimpleProofState:apply_rule(rule, goal)
   local retval =  rule:apply(self, goal)
   return retval
end

function SimpleProofState:devar()
   local var_assgnm =  self:new_var_assgnm()
   local dev_conclusion =  self:get_conclusion():devar(var_assgnm)
   return self:new_instance(dev_conclusion)
end

function SimpleProofState:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::male::SimpleProofState "))
   self:get_conclusion():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function SimpleProofState:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::male::SimpleProofState"))
   local is_last_elem_multiple_line =  true

   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}

   is_last_elem_multiple_line =
      self:get_conclusion():__diagnose_complex(deeper_indentation)

   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return SimpleProofState
