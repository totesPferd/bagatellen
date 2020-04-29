require "rwlock"
local myRwlock = rwlock.create()
myRwlock:writeLock()
myRwlock:writeLock()
