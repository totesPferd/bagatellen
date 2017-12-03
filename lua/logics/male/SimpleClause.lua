local Type =  require "base.type.aux.Type"
local SimpleClause =  Type:__new()


package.loaded["logics.male.SimpleClause"] =  SimpleClause
local Indentation =  require "base.Indentation"
local Set =  require "base.type.Set"
local String =  require "base.type.String"
local VarAssgnm =  require "logics.male.VarAssgnm"

function SimpleClause:new(premis, conclusion)
   local retval =  self:__new()
   retval.premis =  premis
   retval.conclusion =  conclusion
   return retval
end

function SimpleClause:new_instance(premis, conclusion)
   return SimpleClause:new(premis, conclusion)
end

function SimpleClause:get_premis()
   return self.premis
end

function SimpleClause:get_conclusion()
   return self.conclusion
end

function SimpleClause:set_settable_switch(mode)
   self:get_conclusion():set_settable_switch(mode)
   local premis =  self:get_premis()
   if premis
   then
      premis:set_settable_switch(mode)
   end
end

function SimpleClause:equate(goal)
   return self:get_conclusion():equate(goal)
end

function SimpleClause:devar()
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

function SimpleClause:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::male::SimpleClause "))
   local premis =  self:get_premis()
   if premis
   then
      self:get_premis():__diagnose_single_line(indentation)
   end
   indentation:insert(String:string_factory(" "))
   self:get_conclusion():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function SimpleClause:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::male::SimpleClause"))
   local is_last_elem_multiple_line =  true
   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   local premis =  self:get_premis()
   if premis
   then
      deeper_indentation:insert_newline()
      self:get_premis():__diagnose_complex(deeper_indentation)
   end
   deeper_indentation:insert_newline()
   is_last_elem_multiple_line =
      self:get_conclusion():__diagnose_complex(deeper_indentation)
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return SimpleClause
