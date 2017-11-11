local Type =  require "base.type.aux.Type"

local Interface =  Type:__new()

package.loaded["logics.place.general.Interface"] =  Interface

function Interface:new()
   return self:__new()
end

function Interface:get_variable()
end

function Interface:get_val()
end

function Interface:backup()
end

function Interface:restore()
end

function Interface:equate(val)
end

return Interface
