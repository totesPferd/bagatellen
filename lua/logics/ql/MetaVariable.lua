local MALEMetaVariable =  require "logics.male.MetaVariable"

local MetaVariable =  MALEMetaVariable:__new()

package.loaded["logics.ql.MetaVariable"] =  MetaVariable
local List =  require "base.type.List"

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

function MetaVariable:destruct_constant(constant)
   local this_val =  self:get_val()
   if not this_val
   then
      self:set_val(constant)
      return constant
   end
end

return MetaVariable
