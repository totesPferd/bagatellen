local MALEObjectVariable =  require "logics.male.ObjectVariable"

local ObjectVariable =  MALEObjectVariable:__new()

package.loaded["logics.ql.ObjectVariable"] =  ObjectVariable

function ObjectVariable:new(qualifier)
   local retval =  MALEObjectVariable.new(self)
   retval.qualifier =  qualifier
   return retval
end

function ObjectVariable:new_instance()
   return ObjectVariable:new(self:get_qualifier())
end

function ObjectVariable:get_constant()
end

function ObjectVariable:append_qualifier(qualifier)
   self.qualifier:append_qualifier(qualifier)
end

function ObjectVariable:get_qualifier()
   return self.qualifier
end

function ObjectVariable:destruct_constant(constant)
end

function ObjectVariable:equate(other)
   local retval =  false
   local new_qualifier =  other:get_qualifier():get_rhs_chopped_copy(
         self:get_qualifier() )
   if new_qualifier
   then
      retval =  MALEObjectVariable.equate(self, self:new(new_qualifier))
   end
   return retval
end

function ObjectVariable:devar(var_assgnm)
   return MALEObjectVariable.devar(self, var_assgnm):append_qualifier(
         self:get_qualifier() )
end

return ObjectVariable
