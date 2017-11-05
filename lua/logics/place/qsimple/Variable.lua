local GeneralVariable =  require "logics.place.general.Variable"

local Variable =  GeneralVariable:__new()

package.loaded["logics.place.qsimple.Variable"] =  Variable
local Qualifier =  require "logics.place.qualified.Qualifier"

function Variable:copy_factory(variable)
   local retval =  GeneralVariable.new(self)
   retval.variable =  variable
   return retval
end

function Variable:is_system(system)
   if system == "qsimple"
   then
      return self
   end
end

function Variable:get_base_variable()
   return self.variable
end

function Variable:get_val()
   return self:get_base_variable():get_val()
end

function Variable:set_val(val)
   self:get_base_variable():set_val(val)
end

function Variable:get_base()
   local val =  self:get_val()
   if val
   then
      return val:get_base()
   else
      return self:get_base_variable()
   end
end

function Variable:get_qualifier()
   local val =  self:get_val()
   if val
   then
      return val:get_qualifier()
   else
      return Qualifier:id_factory()
   end
end

function Variable:get_chopped_qualifier_copy(qualifier)
   if qualifier:is_id()
   then
      return self:__clone()
   end
   local val =  self:get_val()
   if val
   then
      return val:get_chopped_qualifier_copy(qualifier)
   end
end

return Variable
