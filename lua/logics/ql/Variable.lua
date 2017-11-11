local MALEVariable =  require "logics.male.Variable"

local Variable =  MALEVariable:__new()

package.loaded["logics.pel.Variable"] =  Variable
local Qualifier =  require "logics.ql.Qualifier"

function Variable:new()
   return MALEVarible.new(self)
end

function Variable:get_compound_expression()
end

function Variable:get_base()
   return self
end

function Variable:get_qualifier()
   return Qualifier:id_factory()
end

return Variable
