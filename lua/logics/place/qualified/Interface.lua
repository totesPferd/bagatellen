local GeneralInterface =  require "logics.place.general.Interface"

local QualifiedInterface =  GeneralInterface:__new()

package.loaded["logics.place.qualified.Interface"] =  QualifiedInterface
local Qualifier =  require "logics.place.qualified.Qualifier"

function QualifiedInterface:new()
   return GeneralInterface.new(self)
end

function QualifiedInterface:get_base_concept()
end

function QualifiedInterface:get_compound()
end

function QualifiedInterface:get_base()
end

function QualifiedInterface:get_qualifier()
end

return QualifiedInterface
