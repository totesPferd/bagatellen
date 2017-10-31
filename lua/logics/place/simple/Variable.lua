local GeneralVariable =  require "logics.place.general.Variable"

local SimpleVariable =  GeneralVariable:__new()

package.loaded["logics.place.simple.Variable"] =  SimpleVariable

function SimpleVariable:new()
   return SimpleVariable:__new()
end

function SimpleVariable:get_term()
end

return SimpleVariable
