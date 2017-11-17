local Type =  require "base.type.aux.Type"

local ValueStore =  Type:__new()

package.loaded["logics.male.ValueStore"] =  ValueStore

function ValueStore:new()
   return self:__new()
end

function ValueStore:get_val()
   return self.val
end

function ValueStore:set_val(val)
   self.val =  val
end

return ValueStore
