local MALEUnsettable =  require "logics.male.Unsettable"
local Unsettable =  MALEUnsettable:__new()

package.loaded["logics.ql.Unsettable"] =  Unsettable

function Unsettable:destruct_terminal(terminal)
end

return Unsettable
