local Type =  require "base.type.aux.Type"

local Variable =  Type:__new()

package.loaded["logics.place.general.Variable"] =  Variable
local Qualifier =  require "logics.place.qualified.Qualifier"

function Variable:new()
   return self:__new()
end

function Variable:get_variable()
   return self
end

function Variable:is_system(system)
   if system == "general"
   then
      return self
   end
end

function Variable:get_val()
   return self.val
end

function Variable:backup()
   self.backup_store =  self.val
   if self.val
   then
      self.val:backup()
   end
end

function Variable:restore()
   self.val =  self.backup_store
   if self.val
   then
      self.val:restore()
   end
end

function Variable:equate(val)
   if self.val
   then
      return self.val:equate(val)
   else
      self.val =  val
      return true
   end
end


-- interface: logics.place.simple.Interface:

function Variable:get_term()
end


-- interface: logics.place.qualified.Interface:

function Variable:get_base_concept()
end

function Variable:get_compound()
end

function Variable:get_base()
   return self
end

function Variable:get_qualifier()
   return Qualifier:id_factory()
end

return Variable
