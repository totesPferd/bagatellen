local Type =  require "base.type.aux.Type"

local MetaVariable =  Type:__new()

package.loaded["logics.ql.MetaVariable"] =  MetaVariable
local Constant =  require "logics.ql.Constant"
local QualifierMetaVariable =  require "logics.qualifier.MetaVariable"
local QualifierObjectVariable =  require "logics.qualifier.ObjectVariable"

function MetaVariable:new(qualifier, male_variable)
   local retval =  self:__new()
   retval.male_variable =  male_variable
   retval.qualifier =  qualifier
   return retval
end

function MetaVariable:new_instance(qualifier)
   return self.__index:new(qualifier, self_get_male_variable())
end

function MetaVariable:new_constant(qualifier, symbol)
   local here_qualifier =  qualifier or self:get_qualifier()
   return Constant:new(here_qualifier, symbol)
end

function MetaVariable:get_qualifier()
   return self.qualifier
end

function MetaVariable:get_male_variable()
   return self.male_variable
end

function MetaVariable:get_variable_cast()
end

function MetaVariable:get_constant_cast()
end

function MetaVariable:get_lhs_chop_constant(constant)
   local this_male_val =  self:get_male_variable():get_val()
   if this_male_val
   then
      local this_constant =  this_male_val:get_constant_cast()
      if this_constant
      then
         this_symbol =  this_constant:get_symbol()
         local another_constant =  new_constant(nil, this_symbol)
         return another_constant:get_lhs_chop_constant(constant)
      end
   else
      local id_qual =  QualifierObjectVariable:new()
      local symbol =  constant:get_symbol()
      local qual =  constant:get_qualifier()
      if qual:lu(self:get_qualifier())
      then
         self:get_male_variable():set_val(new_constant(id_qual, symbol))
         self:get_qualifier():set_val(constant:get_qualifier())
      end
   end
end

function MetaVariable:devar(var_assgnm)
   local dev_male =  self:get_male_variable()
   local dev_qual =  self:get_qualifier()
   return self.__index:new(dev_qual, dev_male)
end

return MetaVariable
