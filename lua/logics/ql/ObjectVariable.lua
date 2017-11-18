local MALEObjectVariable =  require "logics.male.ObjectVariable"

local ObjectVariable =  MALEObjectVariable:__new()

package.loaded["logics.ql.ObjectVariable"] =  ObjectVariable

function ObjectVariable:new(male_variable, qualifier)
   local retval =  MALEObjectVariable.new(self)
   retval.male_variable =  male_variable or MALEObjectVariable:new()
   retval.qualifier =  qualifier
   return retval
end

function ObjectVariable:new_ql_instance_added_qualifier(qualifier)
   local new_qual =  self:get_qualifier():__clone()
   new_qual:append_qualifier(qualifier)
   return self:new_ql_instance(new_qual)
end

function ObjectVariable:new_ql_instance(qualifier)
   return self.__index:new(
         self:get_male_variable()
      ,  qualifier )
end

function ObjectVariable:copy()
   return self.__index:new(
      ,  self:get_male_variable():copy()
         self:get_qualifier() )
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
      return male_val:new_ql_instance_added_qualifier(
         self:get_qualifier() )
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


-- --- refactoring:

function ObjectVariable:get_rhs_chopped_copy(qualifier)
   local new_lhs, new_rhs
      =  self:get_qualifier():get_rhs_chopped_copy(qualifier)
   if new_lhs
   then
      return
            self:__index:new(
                  self:get_meta_variable()
               ,  new_lhs )
         ,  new_rhs
   end
end

function ObjectVariable:append_qualifier(qualifier)
   self:get_qualifier():append_qualifier(qualifier)
end

return ObjectVariable
