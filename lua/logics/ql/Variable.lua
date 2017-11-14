local MALEVariable =  require "logics.male.Variable"

local Variable =  MALEVariable:__new()

package.loaded["logics.ql.Variable"] =  Variable
local Qualifier =  require "logics.ql.Qualifier"

function Variable:new()
   return MALEVariable.new(self)
end

function Variable:get_concept()
end

function Variable:get_base_qualifier()
   return self, Qualifier:id_factory()
end

function Variable:destruct_concept(concept)
end

return Variable
