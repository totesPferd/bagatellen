local Type =  require "base.type.aux.Type"

local Variable =  Type:__new()

package.loaded["logics.place.general.Variable"] =  Variable

function Variable:new()
   return Variable:__new()
end

function Variable:get_variable()
   return self
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

return Variable
