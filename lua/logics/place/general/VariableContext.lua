local Type =  require "base.type.aux.Type"

local VariableContext =  Type:__new()

package.loaded["logics.place.general.VariableContext"] =  VariableContext
local List =  require "base.type.List"

function VariableContext:new()
   local retval =  self:__new()
   retval.variables =  List:empty_factory()
   return retval
end

function VariableContext:add_variable(variable)
   self.variables:append(variable)
end

function VariableContext:add_variable_context(other)
   self.variables:append_list(other.variables)
end

function VariableContext:equate(other)
   for variable in self.variables:elems()
   do variable:backup()
   end
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
   if not equatable
   then
      for variable in self.variables:elems()
      do variable:restore()
      end
   end
   return equatable
end

return VariableContext
