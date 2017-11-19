local MALEObjectVariable =  require "logics.male.ObjectVariable"

local ObjectVariable =  MALEObjectVariable:__new()

package.loaded["logics.ql.ObjectVariable"] =  ObjectVariable
local Constant =  require "logics.ql.Constant"

function ObjectVariable:new()
   return MALEObjectVariable.new(self)
end

function ObjectVariable:get_constant_cast()
end

function ObjectVariable:get_lhs_chop_constant(other)
   local this_male_val =  self:get_val()
   if this_male_val
   then
      return this_constant:get_lhs_chop_constant(other)
   end
end

return ObjectVariable
