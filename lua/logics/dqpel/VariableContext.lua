local Type =  require "base.type.aux.Type"

local VariableContext =  Type:__new()

package.loaded["logics.dqpl.VariableContext"] =  VariableContext
local List =  require "base.type.List"
local MALEVarAssgnm =  require "logics.male.VarAssgnm"
local String =  require "base.type.String"
local StringSet =  require "base.type.set.StringSet"

function VariableContext:new()
   local retval =  self:__new()
   retval.variables =  List:empty_list_factory()
   return retval
end

function VariableContext:add_variable(variable)
   self.variables:append(variable)
end

function VariableContext:add_variable_context(other)
   self.variables:append_list(other.variables)
end

function VariableContext:equate(other)
   local equatable =  true

-- use zip as soon as available
   local other_variables =  other.variables:clone()
   for variable in self.variables:elems()
   do local other_variable =  other_variables:get_head()
      other_variables:cut_head()
      equatable =  variable:equate(other_variable)
      if not equatable
      then break
      end
   end
   return equatable
end

function VariableContext:devar()
   local var_assgnm =  VarAssgnm:new()
   local retval =  self:new()

-- map/reduce et al.!!!
   for var in self.variables:elems()
   do retval.variables:append(var:devar(var_assgnm))
   end

   return retval
end

function VariableContext:uniquize()
   local do_not_use_set =  StringSet:empty_set_factory()
   for variable in self.variables:elems()
   do local name =  variable:get_name() or String:string_factory("x")
      while do_not_use_set:is_in(name)
      do name:append_string(String:string_factory("'"))
      end
      variable:set_name(name)
      do_not_use_set:add(name)
   end
end

function VariableContext:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::dqpel::VariableContext"))
   for variable in self.variables:elems()
   do
      variable:__diagnose_single_line(indentation)
   end
   indentation:insert(String:string_factory(")"))
end

function VariableContext:__diagnose_multiple_line(indentation)
   local is_last_elem_multiple_line =  false
   indentation:insert(String:string_factory("(logics::dqpel::VariableContext"))
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   for variable in self.variables:elems()
   do
      deeper_indentation:insert_newline()
      is_last_elem_multiple_line
         =  variable:__diagnose_complex(deeper_indentation)
   end
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return VariableContext
