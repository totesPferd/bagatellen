local Type =  require "base.type.aux.Type"

local Clause =  Type:__new()


package.loaded["logics.male.Clause"] =  Clause
local ContectedTerm =  require "logics.male.ContectedTerm"
local Indentation =  require "base.Indentation"
local Set =  require "base.type.Set"
local String =  require "base.type.String"
local VarAssgnm =  require "logics.male.VarAssgnm"

function Clause:new(var_ctxt, premises, conclusion)
   local retval =  self:__new()
   retval.var_ctxt =  var_ctxt
   retval.premises =  premises
   retval.conclusion =  conclusion
   return retval
end

function Clause:new_instance(var_ctxt, premises, conclusions)
   return Clause:new(var_ctxt, premises, conclusions)
end

function Clause:new_contected_term(var_ctxt, term)
   return ContectedTerm:new(var_ctxt, term)
end

function Clause:get_var_ctxt()
   return self.var_ctxt
end

function Clause:get_premises()
   return self.premises
end

function Clause:get_conclusion()
   return self.conclusion
end

function Clause:get_contected_premises()
   local retval =  Set:empty_set_factory()
   local var_ctxt =  self:get_var_ctxt()
   for premis in self:get_premises():elems()
   do retval:add(self:new_contected_term(
            var_ctxt
         ,  premis ))
   end
   return retval
end

function Clause:get_contected_conclusion()
   local var_ctxt =  self:get_var_ctxt()
   return self:new_contected_term(var_ctxt, self:get_conclusion())
end

function Clause:equate(goal)
   self.var_ctxt =  goal:get_var_ctxt()
   return self:get_contected_conclusion():equate(goal)
end

function Clause:new_var_assgnm()
   return VarAssgnm:new()
end

-- Kopie von sich ohne Variablen-Bindungen.
-- (so eine Art __clone)
function Clause:devar()
   local var_assgnm =  self:new_var_assgnm()
   local new_var_ctxt =  self:get_var_ctxt():devar(var_assgnm)
-- gut fuer map-function
   local new_premises =  Set:empty_set_factory()
   for premis in self:get_premises():elems()
   do new_premises:add(premis:devar(var_assgnm))
   end
   local new_conclusion =  self:get_conclusion():devar(var_assgnm)
   return self:new_instance(new_var_ctxt, new_premises, new_conclusion)
end

function Clause:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::male::Clause "))
   self:get_var_ctxt():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(" "))
   self:get_premises():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(" "))
   self:get_conclusion():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function Clause:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::male::Clause"))
   local is_last_elem_multiple_line =  true

   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   is_last_elem_multiple_line =
      self:get_var_ctxt():__diagnose_complex(deeper_indentation)

   deeper_indentation:insert_newline()
   is_last_elem_multiple_line =
      self:get_premises():__diagnose_complex(deeper_indentation)

   deeper_indentation:insert_newline()
   is_last_elem_multiple_line =
      self:get_conclusion():__diagnose_complex(deeper_indentation)

   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return Clause
