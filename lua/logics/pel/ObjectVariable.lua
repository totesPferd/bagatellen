local MALEObjectVariable =  require "logics.male.ObjectVariable"

local ObjectVariable =  MALEObjectVariable:__new()

package.loaded["logics.pel.ObjectVariable"] =  ObjectVariable

function ObjectVariable:new()
   return MALEObjectVariable.new(self)
end

function ObjectVariable:get_compound_cast()
end

function ObjectVariable:destruct_compound(symbol, aritiy)
end

return ObjectVariable
