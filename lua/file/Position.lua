local Type =  require "base.type.aux.Type"

local Position =  Type:__new()


package.loaded["file.Position"] =  Position
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"

function Position:new(filename)
   local retval =  self:__new()
   retval.lineno =  1
   retval.colno =  1
   retval.filename =  filename
   return retval
end

function Position:get_lineno()
   return self.lineno
end

function Position:get_colno()
   return self.colno
end

function Position:get_filename()
   return self.filename
end

function Position:next_line()
   self.lineno =  self.lineno +1
   self.colno =  1
end

function Position:next_col()
   self.colno =  self.colno + 1
end

function Position:__tostring()
   return
         tostring(self:get_filename())
      .. "("
      .. tostring(self:get_lineno())
      .. ":"
      .. tostring(self:get_colno())
      .. ")"
end

function Position:get_report(msg)
   return String:string_factory(
         "@"
      .. self:__tostring()
      .. ": "
      .. tostring(msg) )
end

function Position:get_included_from_line()
   return String:string_factory(
         "included from "
      .. self:__tostring() )
end

function Position:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(
         "(file::Position "
      .. self:__tostring()
      .. ")" ))
end

function Position:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(file::Position"))
   indentation:insert_newline()
   do
      local deeper_indentation =
         indentation:get_deeper_indentation_factory {}
      deeper_indentation:insert(String:string_factory(self:__tostring()))
      deeper_indentation:insert(String:string_factory(" )"))
      deeper_indentation:save()
   end
end

return Position
