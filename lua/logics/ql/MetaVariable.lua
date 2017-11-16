local MALEMetaVariable =  require "logics.male.MetaVariable"

local MetaVariable =  MALEMetaVariable:__new()

package.loaded["logics.pel.MetaVariable"] =  MetaVariable
local List =  require "base.type.List"

function MetaVariable:new()
   return MALEMetaVariable.new(self)
end

function MetaVariable:be_a_constant(constant)
   local this_val =  self:get_val()
   if not this_val
   then
      self:set_val(constant)
      return constant
   end
end

return MetaVariable
