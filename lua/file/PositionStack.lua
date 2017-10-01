local Position =  require "file.Position"

local PositionStack =  Position:__new()


package.loaded["file.PositionStack"] =  PositionStack
local Indentation =  require "base.Indentation"
local List =  require "base.type.List"
local String =  require "base.type.String"

function PositionStack:new(filename)
   local retval =  PositionStack:__new()
   retval.stack =  List:list_factory { Position:new(filename) }
   return retval
end

function PositionStack:add(position)
   self.stack:append(position)
end

function PositionStack:close_hpos()
   self.stack:cut_tail()
end

function PositionStack:get_hpos()
   return self.stack:get_tail()
end

function PositionStack:get_lineno()
   return self:get_hpos():get_lineno()
end

function PositionStack:get_colno()
   return self:get_hpos():get_colno()
end

function PositionStack:get_filename()
   return self:get_hpos():get_filename()
end

function PositionStack:next_line()
   self:get_hpos():next_line()
end

function PositionStack:next_col()
   self:get_hpos():next_col()
end

function PositionStack:get_report(msg)
   local retval =  String:empty_string_factory()
   local prev_line =  nil
   for p in self.stack:elems()
   do if prev_line
      then
         retval:append_string(prev_line:get_included_from_line())
         retval:append_newline()
      end
      prev_line = p
   end
   retval:append_string(prev_line:get_report(msg))
   return retval
end

function PositionStack:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(file::PositionStack"))
   for elem in self.stack:elems()
   do
      indentation:insert(String:string_factory(" "))
      elem:__diagnose_single_line(indentation)
   end
   indentation:insert(String:string_factory(")"))
end

function PositionStack:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(file::PositionStack"))
   local is_last_elem_multiple_line =  true
   for elem in self.stack:elems()
   do
      indentation:insert_newline()
      local deeper_indentation =
         indentation:get_deeper_indentation_factory {}
      is_last_elem_multiple_line =
         elem:__diagnose_complex(deeper_indentation)
      deeper_indentation:save()
   end
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return PositionStack
