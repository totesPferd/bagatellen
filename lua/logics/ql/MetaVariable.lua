local MALEMetaVariable =  require "logics.male.MetaVariable"

local MetaVariable =  MALEMetaVariable:__new()

package.loaded["logics.ql.MetaVariable"] =  MetaVariable
local List =  require "base.type.List"
local ObjectVariable =  require "logics.ql.ObjectVariable"
local QualifierVariable =  require "logics.ql.QualifierVariable"

function MetaVariable:new()
   return MALEMetaVariable.new(self)
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
   end
end

function MetaVariable:be_a_constant(constant)
   local this_val =  self:get_val()
   if not this_val
   then
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
      return self
   end
end

return MetaVariable
