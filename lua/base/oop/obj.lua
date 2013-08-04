return {
   __new =  function(self)
      local obj =  {
            __add =  self.__add
         ,  __call =  self.__call
         ,  __concat =  self.__concat
         ,  __div =  self.__div
         ,  __eq =  self.__eq
         ,  __gc =  self.__gc
         ,  __index =  self
         ,  __le =  self.__le
         ,  __lt =  self.__lt
         ,  __len =  self.__len
         ,  __mod =  self.__mod
         ,  __mul =  self.__mul
         ,  __newindex =  self.__newindex
         ,  __pow =  self.__pow
         ,  __sub =  self.__sub
         ,  __tostring =  self.__tostring
         ,  __unm =  self.__unm

         ,  __clone =  self.__clone or function(self)
            local super_obj =  self.__index or self
            local copied_super_obj
            if super_obj.__clone
            then
               copied_super_obj =  super_obj:__clone()
            else
               copied_super_obj =  super_obj
            end
            local retval =  copied_super_obj:__new()
            for k, v in pairs(self)
            do local new_component
               if type(v) == "table" and v.__clone
               then
                  new_component = v:__clone()
               else
                  new_component = v
               end
               retval[k] =  new_component
            end
            return retval
         end
      }
      setmetatable(obj, obj)
      return obj
   end
}
