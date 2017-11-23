local SimpleRule =  require "logics.male.SimpleRule"

local Resolve =  SimpleRule:__new()


package.loaded["logics.male.simple_rule.Resolve"] =  Resolve
local Indentation =  require "base.Indentation"
local Set =  require "base.type.Set"
local String =  require "base.type.String"
local VarAssgnm =  require "logics.male.VarAssgnm"

function Resolve:get_resolve_cast()
   return self
end

function Resolve:new(premis, conclusion)
   local retval =  SimpleRule.new(self)
   retval.premis =  premis
   retval.conclusion =  conclusion
   return retval
end

function Resolve:new_instance(premis, conclusion)
   return Resolve:new(premis, conclusion)
end

function Resolve:get_premis()
   return self.premis
end

function Resolve:get_conclusion()
   return self.conclusion
end

function Resolve:apply(simple_proof_state, goal)
   return simple_proof_state:resolve(
         self:get_premis()
      ,  self:get_conclusion()
      ,  goal )
end

function Resolve:equate(goal)
   return self:get_conclusion():equate(goal)
end

function Resolve:devar()
   local var_assgnm =  VarAssgnm:new()
   local premis =  self:get_premis()
   local dev_premis
   if premis
   then
      dev_premis =  self:get_premis():devar(var_assgnm)
   end
   local dev_conclusion =  self:get_conclusion():devar(var_assgnm)
   return self:new_instance(dev_premis, dev_conclusion)
end

function Resolve:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::male::simple_rule::Resolve "))
   local premis =  self:get_premis()
   if premis
   then
      self:get_premis():__diagnose_single_line(indentation)
   end
   indentation:insert(String:string_factory(" "))
   self:get_conclusion():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function Resolve:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::male::simple_rule::Resolve"))
   local is_last_elem_multiple_line =  true
   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   local premis =  self:get_premis()
   if premis
   then
      self:get_premis():__diagnose_complex(deeper_indentation)
      indentation:insert_newline()
   end
   is_last_elem_multiple_line =
      self:get_conclusion():__diagnose_complex(deeper_indentation)
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return Resolve
