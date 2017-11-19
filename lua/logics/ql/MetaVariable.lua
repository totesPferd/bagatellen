local MALEMetaVariable =  require "logics.male.MetaVariable"

local MetaVariable =  MALEMetaVariable:__new()

package.loaded["logics.ql.MetaVariable"] =  MetaVariable
local List =  require "base.type.List"
local ObjectVariable =  require "logics.ql.ObjectVariable"
local QualifierVariable =  require "logics.ql.QualifierVariable"

function MetaVariable:new(male_variable, qualifier)
   local retval =  MALEMetaVariable.new(self)
   retval.qualifier =  qualifier
   retval.male_variable =  male_variable or MALEMetaVariable:new()
   return retval
end

function MetaVariable:new_ql_instance_added_qualifier(qualifier)
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:new_ql_instance_added_qualifier(qualifier)
   end
end

function MetaVariable:new_object_variable(qualifier)
   return ObjectVariable:new(nil, qualifier)
end

function MetaVariable:get_constant()
   local this_val =  self:get_val()
   if this_val
   then
      return self:get_constant()
   end
end

function MetaVariable:get_qualifier()
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:get_qualifier()
   else
      return self.qualifier
   end
end

function MetaVariable:append_qualifier(qualifier)
   self:get_qualifier():append_qualifier(qualifier)
end

function MetaVariable:get_male_variable()
   return self.male_variable
end

function MetaVariable:be_a_constant(constant)
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:be_a_constant(constant)
   else
      self:set_val(constant)
      return constant
   end
end

function MetaVariable:get_rhs_chopped_copy(qualifier)
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:get_rhs_chopped_copy(qualifier)
   else
      local new_val =  self:new_obj_variable(qualifier)
      self:set_val(new_val)
      local new_male_val =  new_val:get_male_variable()
      local new_qual =  self:new_qualifier_variable()
      local new_obj_val =  self:new_object_variable(new_qual)
      return new_obj_val, new_qual:get_id_qualfier_end()
   end
end

function MetaVariable:devar(var_assgnm)
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:devar(var_assgnm)
   else
      local dev_male =  self:get_male_variable():devar(var_assgnm)
      local dev_qual =  self:get_qualifier():devar(var_assgnm)
      return self.__index:new(dev_male, dev_qual)
   end
end

return MetaVariable
