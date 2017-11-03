local GeneralInterface =  require "logics.place.simple.Interface"

local Interface =  GeneralInterface:__new()

package.loaded["logics.pel.term.Interface"] =  Interface
local String =  require "base.type.String"

function Interface:new()
   local retval =  GeneralInterface.new(self)
   return retval
end

function Interface:get_sort()
end

function Interface:get_compound()
end

return Interface
