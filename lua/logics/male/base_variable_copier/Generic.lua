local Type =  require "base.type.aux.Type"

local Generic =  Type:__new()

package.loaded["logics.male.base_variable_copier.General"] =  General

function Generic:new()
   self.__index:new()
end

return Generic
