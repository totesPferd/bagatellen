local Registry =  (require "base.oop.obj"):__new()

function Registry:new()
   local retval =  self:__new()
   retval.reg_dict =  {}
   return retval
end

function Registry:add_root(obj)
   self.reg_dict[obj:get_registry_key()] =  obj
end

function Registry:get_obj(path)
   local cur_reg =  self
   local sub_obj =  nil
   for _, comp in pairs(path:get_comps())
   do sub_obj =  cur_reg.reg_dict[comp]
      if sub_obj
      then
         cur_reg =  cur_reg.reg_dict[comp]:get_registry()
      else
         return
      end
   end
   return sub_obj, cur_reg
end

return Registry
