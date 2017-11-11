-- Methoden backup und restore sicherlich entbehrlich.
-- Beim equaten sollte man Terme zunächst kopieren und wegschmeißen,
-- soweit sie sich nicht equaten lassen.
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

function Variable:set_val(val)
   self.val =  val
end

function Variable:backup()
   self.backup_store =  self:get_val()
   if self:get_val()
   then
      self:get_val():backup()
   end
end

function Variable:restore()
   self:set_val(self.backup_store)
   if self:get_val()
   then
      self:get_val():restore()
   end
end

function Variable:equate(val)
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:equate(val)
   elseif self == val
   then
      return true
   else
      self:set_val(val)
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
