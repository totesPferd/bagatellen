local GeneralInterface =  require "logics.place.general.Interface"

local SimpleInterface =  GeneralInterface:__new()

package.loaded["logics.place.simple.Interface"] =  SimpleInterface

function SimpleInterface:new()
   return GeneralInterface.new(self)
end

function SimpleInterface:get_term()
end

return SimpleInterface
