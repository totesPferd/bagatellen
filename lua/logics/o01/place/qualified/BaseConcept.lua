local Type =  require "base.type.aux.Type"

local BaseConcept =  Type:__new()

package.loaded["logics.place.qualified.BaseConcept"] =  BaseConcept
local Qualifier =  require "logics.place.qualified.Qualifier"

function BaseConcept:new()
   return self:__new()
end

function BaseConcept:get_base_concept()
   return self
end

function BaseConcept:get_compound()
end

function BaseConcept:get_variable()
end

function BaseConcept:get_val()
   return self
end

function BaseConcept:backup()
end

function BaseConcept:restore()
end

function BaseConcept:equate(val)
   local other_base_concept =  val:get_base_concept()
   return
         other_base_concept
     and self:get_val() == other_base_concept:get_val()
end

function BaseConcept:get_base()
   return self
end

function BaseConcept:get_qualifier()
   return Qualifier:id_factory()
end

return BaseConcept
