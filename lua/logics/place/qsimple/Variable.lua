local GeneralVariable =  require "logics.place.general.Variable"

local Variable =  GeneralVariable:__new()

package.loaded["logics.place.qsimple.Variable"] =  Variable
local Qualifier =  require "logics.place.qualified.Qualifier"

function Variable:qualifying_factory(variable, qualifier)
   local retval =  GeneralVariable.new(self)
   retval.variable =  variable
   retval.qualifier =  qualifier
   return retval
end

function Variable:clone()
   local new_qual =  qualifier:__clone()
   return self:qualifying_factory(variable, new_qual)
end

function Variable:apply_qualifier(qualifier)
   self:get_base_qualifier():append_qualifier(qualifier)
end

function Variable:__eq(other)
   local other_variable =  other:get_variable():is_system("qsimple")
   if other_variable
   then
      return
            self.base == other_variable.base
        and self:get_base_qualifier() == other_variable.qualifier
   else
      return false
   end
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

function Variable:get_base_qualifier()
   return self.qualifier
end

function Variable:get_val()
   local val =  self:get_base_variable():get_val()
   if val
   then
      local retval =  val:clone()
      retval:apply_qualifier(self:get_base_qualifier())
      return retval
   end
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
      local retval =  val:get_qualifier():__clone()
      retval:append_qualifier(self:get_base_qualifier())
      return retval
   else
      return self:get_base_qualifier()
   end
end

function Variable:get_chopped_qualifier_copy(qualifier)
   local new_qual =  self:get_qualifier():get_rhs_chopped_copy(qualifier)
   if new_qual
   then
      return self:qualifying_factory(
            self:get_base()
         ,  new_qual )
   end
end

return Variable
