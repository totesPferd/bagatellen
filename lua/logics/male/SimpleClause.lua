local Type =  require "base.type.aux.Type"
local SimpleClause =  Type:__new()


package.loaded["logics.male.SimpleClause"] =  SimpleClause
local ContectedTerm =  require "logics.male.ContectedTerm"
local Indentation =  require "base.Indentation"
local Set =  require "base.type.Set"
local String =  require "base.type.String"
local VarAssgnm =  require "logics.male.VarAssgnm"

function SimpleClause:new(var_ctxt, premis, conclusion)
   local retval =  self:__new()
   retval.var_ctxt =  var_ctxt
   retval.premis =  premis
   retval.conclusion =  conclusion
   return retval
end

function SimpleClause:new_instance(var_ctxt, premis, conclusion)
   return SimpleClause:new(var_ctxt, premis, conclusion)
end

function SimpleClause:new_contected_term(var_ctxt, term)
   return ContectedTerm:new(var_ctxt, term)
end

function SimpleClause:get_var_ctxt()
   return self.var_ctxt
end

function SimpleClause:get_premis()
   return self.premis
end

function SimpleClause:get_conclusion()
   return self.conclusion
end

function SimpleClause:get_contected_premis()
   local premis =  self:get_premis()
   if premis
   then
      local var_ctxt =  self:get_var_ctxt()
      return self:new_contected_term(var_ctxt, premis)
   end
end

function SimpleClause:get_contected_conclusion()
   local conclusion =  self:get_conclusion()
   local var_ctxt =  self:get_var_ctxt()
   return self:new_contected_term(var_ctxt, conclusion)
end


function SimpleClause:equate(goal)
   local retval =  self:get_contected_conclusion():equate(goal)
   self.var_ctxt =  goal:get_var_ctxt()
   return retval
end

function SimpleClause:devar()
   local var_assgnm =  VarAssgnm:new()
   local dev_var_ctxt =  self:get_var_ctxt():devar(var_assgnm)
   local premis =  self:get_premis()
   local dev_premis
   if premis
   then
      dev_premis =  self:get_premis():devar(var_assgnm)
   end
   local dev_conclusion =  self:get_conclusion():devar(var_assgnm)
   return self:new_instance(dev_var_ctxt, dev_premis, dev_conclusion)
end

function SimpleClause:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::male::SimpleClause "))
   self:get_var_ctxt():__diagnose_single_line(indentation)
   local premis =  self:get_premis()
   if premis
   then
      indentation:insert(String:string_factory(" "))
      self:get_premis():__diagnose_single_line(indentation)
   end
   indentation:insert(String:string_factory(" "))
   self:get_conclusion():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function SimpleClause:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::male::SimpleClause"))
   local is_last_elem_multiple_line =  true
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}

   deeper_indentation:insert_newline()
   is_last_elem_multiple_line =
      self:get_var_ctxt():__diagnose_complex(deeper_indentation)

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
