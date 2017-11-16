local MALEVariable =  require "logics.male.Variable"

local Variable =  MALEVariable:__new()

package.loaded["logics.ql.Variable"] =  Variable

function Variable:new(qualifier)
   local retval =  MALEVariable.new(self)
   retval.qualifier =  qualifier
   return retval
end

function Variable:new_instance()
   return Variable:new(self:get_qualifier())
end

function Variable:get_constant()
end

function Variable:append_qualifier(qualifier)
   self.qualifier:append_qualifier(qualifier)
end

function Variable:get_qualifier()
   return self.qualifier
end

function Variable:destruct_constant(constant)
end

function Variable:equate(other)
   local retval =  false
   local new_qualifier =  other:get_qualifier():get_rhs_chopped_copy(
         self:get_qualifier() )
   if new_qualifier
   then
      retval =  MALEVariable.equate(self, self:new(new_qualifier))
   end
   return retval
end

function Variable:devar(var_assgnm)
   return MALEVariable.devar(self, var_assgnm):append_qualifier(
         self:get_qualifier() )
end

return Variable
