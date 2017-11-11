local MALEVariable =  require "logics.male.Variable"

local Variable =  MALEVariable:__new()

package.loaded["logics.pel.Variable"] =  Variable

function Variable:new()
   return MALEVarible.new(self)
end

function Variable:get_compound_expression()
end

return Variable
