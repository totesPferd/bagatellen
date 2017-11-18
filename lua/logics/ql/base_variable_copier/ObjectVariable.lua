local Type =  require "base.type.aux.Type"

local Variable =  Type:__new()

function Variable:new()
   return self.__index:new_ql_variable(
         self:get_male_variable():get_base_variable_copier():new()
      ,  self:get_qualifier() )
end

return Variable
