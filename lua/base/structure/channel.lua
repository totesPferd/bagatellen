local Channel =  (require "base.oop.obj"):__new()

function Channel:new()
   local retval =  self:__new()
   retval.coroutine =  nil
   return retval
end

function Channel:start()
   self.coroutine =  coroutine.create(self.doit)
   coroutine.resume(self.coroutine, self)
   self:abstract_log("started")
end

function Channel:deliver(conn, meth, msg)
   self:perform_deliver(conn, meth, msg)
   coroutine.resume(self.coroutine, conn, meth, msg)
   self:abstract_log("sent", conn, meth, msg)
end

function Channel:wait()
   local conn, meth, msg =  coroutine.yield()
   self:perform_serve(conn, meth, msg)
   self:abstract_log("received", conn, meth, msg)
   return conn, meth, msg
end

function Channel:perform_deliver()
end

function Channel:perform_serve(conn, meth, msg)
end

function Channel:doit()
end

function Channel:abstract_log(event, conn, meth, msg)
end

return Channel

