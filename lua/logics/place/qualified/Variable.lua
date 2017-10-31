local GeneralVariable =  require "logics.place.general.Variable"

local QualifiedVariable =  GeneralVariable:__new()

package.loaded["logics.place.qualified.Variable"] =  QualifiedVariable
local Qualifier =  require "logics.place.qualified.Qualifier"

function QualifiedVariable:new()
   return GeneralVariable.new(self)
end

function QualifiedVariable:get_base_concept()
end

function QualifiedVariable:get_compound()
end

function QualifiedVariable:get_base()
   return self
end

function QualifiedVariable:get_qualifier()
   return Qualifier:id_factory()
end

return QualifiedVariable
