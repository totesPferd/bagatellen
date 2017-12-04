local MALEUnsettable =  require "logics.male.Unsettable"
local Unsettable =  MALEUnsettable:__new()

package.loaded["logics.pel.Unsettable"] =  Unsettable

function Unsettable:destruct_compound(symbol, arity)
end

return Unsettable
