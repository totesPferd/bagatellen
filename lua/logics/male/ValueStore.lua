local Type =  require "base.type.aux.Type"

local ValueStore =  Type:__new()

package.loaded["logics.male.ValueStore"] =  ValueStore

function ValueStore:new(settable)
   local retval =  self:__new()
   retval.settable_switch =  settable or false
   return retval
end

function ValueStore:is_settable()
   return self.settable_switch
end

function ValueStore:set_settable_switch(mode)
   self.settable_switch =  mode
end

function ValueStore:get_val()
   return self.val
end

function ValueStore:set_val(val)
   local retval =  self:is_settable()
   if retval
   then
      self.val =  val
   end
   return retval
end

return ValueStore
