local QualifiedInterface =  require "logics.place.qualified.Interface"

local Interface =  QualifiedInterface:__new()

package.loaded["logics.ql.term.Interface"] =  Interface
local Compound =  require "logics.ql.term.Compound"

function Interface:new()
   local retval =  self:__new()
   return retval
end

function Interface:get_sort()
end

function Interface:get_base_spec()
end

function Interface:get_qualifier()
end

function Interface:get_base_concept()
end

function Interface:get_compound()
end

function Interface:get_qualified(qualifier)
   return Compound:new(self, qualifier)
end

return Interface
