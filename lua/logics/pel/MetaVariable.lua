local MALEMetaVariable =  require "logics.male.MetaVariable"

local MetaVariable =  MALEMetaVariable:__new()

package.loaded["logics.pel.MetaVariable"] =  MetaVariable
local List =  require "base.type.List"

function MetaVariable:new()
   return MALEMetaVariable.new(self)
end

function MetaVariable:get_compound_cast()
end

function MetaVariable:copy()
   return self.__index:new()
end

function MetaVariable:destruct_compound(symbol, arity)
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:destruct_compound(symbol, arity)
   else
-- map/reduce et al.!!!
      local retval =  List:empty_list_factory()
      for i = 1,arity
      do retval:append(self:copy())
      end
      self:set_val(retval)
      return retval:__clone()
   end
end

return MetaVariable
