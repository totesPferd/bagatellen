local Type =  require "base.type.aux.Type"

local VariableSpec =  Type:__new()

package.loaded["logics.pel.VariableSpec"] =  VariableSpec
local List =  require "base.type.List"
local String =  require "base.type.String"
local StringSet =  require "base.type.set.StringSet"

function VariableSpec:new()
   local retval =  self:__new()
   retval.variables =  List:empty_list_factory()
   return retval
end

function VariableSpec:get_variable_list()
   return self.variables
end

function VariableSpec:add_variable(variable)
   self.variables:append(variable)
end

function VariableSpec:add_variable_spec(variable_spec)
   self.variables:append_list(variable_spec:get_variable_list())
end

function VariableSpec:uniquize()
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

return VariableSpec
