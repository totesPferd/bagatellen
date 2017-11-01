local GeneralInterface =  require "logics.place.simple.Interface"

local Interface =  Type:__new()

package.loaded["logics.pel.term.Interface"] =  Interface
local String =  require "base.type.String"
local Substitution =  require "logics.pel.Substitution"

function Interface:new()
   local retval =  GeneralInterface.new(self)
   return retval
end

function Interface:get_sort()
end

function Interface:get_compound()
end

return Interface
