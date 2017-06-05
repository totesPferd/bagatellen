class Bozo:

   def __init__(self, col, line, msg):
      self.col =  col
      self.line =  line
      self.msg =  msg

   def get_col(self):
      return self.col

   def get_line(self):
      return self.line

   def get_msg(self):
      return self.msg


def from_feed_object(feed_object):
   if feed_object.bozo != 0:
      col =  feed_object.bozo_exception.getColumnNumber()
      line =  feed_object.bozo_exception.getLineNumber()
      msg =  feed_object.bozo_exception.getMessage()
      return Bozo(col, line, msg)
