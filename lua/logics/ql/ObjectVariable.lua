local MALEObjectVariable =  require "logics.male.ObjectVariable"

local ObjectVariable =  MALEObjectVariable:__new()

package.loaded["logics.ql.ObjectVariable"] =  ObjectVariable

function ObjectVariable:new(qualifier)
   local male_variable =  MALEObjectVariable:new()
   return self:new_ql_variable(male_variable, qualifier)
end

function ObjectVariable:new_ql_variable(male_variable, qualifier)
   local retval =  MALEObjectVariable:__new()
   retval.male_variable =  male_variable
   retval.qualifier =  qualifier
   return retval
end

function ObjectVariable:new_ql_instance(qualifier)
   return self:new_ql_variable(
         self:get_male_variable()
      ,  qualifier )
end

function ObjectVariable:new_instance()
   return self:new_ql_variable(
         self:get_male_variable()
      ,  self:get_qualifier() )
end

function ObjectVariable:get_male_variable()
   return self.male_variable
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

function ObjectVariable:get_val()
   local male_val =  self:get_male_variable():get_val()
   if male_val
   then
      local new_qual =  male_val:get_qualifier():__clone()
      new_qual:append_qualifier(self:get_qualifier())
      return self:new_ql_instance(new_qual)
   end
end

function ObjectVariable:set_val(val)
   local new_qualifier =  val:get_qualifier():get_rhs_chopped_copy(
         self:get_qualifier() )
   if new_qualifier
   then
      self:get_male_variable():set_val(
         val:new_ql_instance(new_qualifier) )
   end
end

function ObjectVariable:__eq(other)
   return
         self:get_male_variable() == other:get_male_variable()
     and self:get_qualifier() == other:get_qualifier()
end

return ObjectVariable
