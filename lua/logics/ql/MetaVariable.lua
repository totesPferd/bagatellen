local MALEMetaVariable =  require "logics.male.MetaVariable"

local MetaVariable =  MALEMetaVariable:__new()

package.loaded["logics.pel.MetaVariable"] =  MetaVariable
local List =  require "base.type.List"

function MetaVariable:new()
   return MALEMetaVariable.new(self)
end

function MetaVariable:be_a_concept(concept)
   local this_val =  self:get_val()
   if not this_val
   then
      self:set_val(concept)
      return concept
   end
end

return MetaVariable
