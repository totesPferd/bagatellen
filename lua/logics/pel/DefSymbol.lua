local Type =  require "base.type.aux.Type"

local DefSymbol =  Type:__new()

package.loaded["logics.pel.DefSymbol"] =  DefSymbol

function DefSymbol:new()
   return self:__new()
end

function DefSymbol:get_def_symbol_cast()
   return self
end

function DefSymbol:get_eq_symbol_cast()
end

function DefSymbol:get_qual_symbol_cast()
end

function DefSymbol:__eq(other)
   local retval =  false
   local other_def_symbol =  other:get_def_symbol()
   if other_def_symbol
   then
      retval =  true
   end
   return retval
end

return DefSymbol

