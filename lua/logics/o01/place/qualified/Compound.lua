local Type =  require "base.type.aux.Type"

local Compound =  Type:__new()

package.loaded["logics.place.qualified.Compound"] =  Compound

function Compound:new(base, qualifier)
   local retval =  self:__new()
   retval.base =  base
   retval.qualifier =  qualifier
   return retval
end

function Compound:get_base_concept()
end

function Compound:get_compound()
   return self
end

function Compound:get_variable()
end

function Compound:get_val()
   return self
end

function Compound:backup()
   self:get_base():backup()
end

function Compound:restore()
   self:get_base():restore()
end

function Compound:equate(val)
   local new_qual
      =  val:get_qualifier():get_rhs_chopped_copy(self:get_qualifier())
   if new_qual
   then
      return self:get_base():equate(Compound:new(val:get_base(), new_qual))
   else
      return false
   end
end

function Compound:get_base()
   return self.base
end

function Compound:get_qualifier()
   return self.qualifier
end

return Compound
