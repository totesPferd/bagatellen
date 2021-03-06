import dctbnbc.content_grabber
import dctbnbc.feed_grabber
import dctbnbc.tally
import json
import sys

class State:

   def __init__(self, filename):
      self.filename =  filename
      self.content_grabber =  dctbnbc.content_grabber.ContentGrabber()
      self.feed_grabber =  dctbnbc.feed_grabber.FeedGrabber()
      self.content_grabber.register_grabber(self.feed_grabber)
      self.tally =  dctbnbc.tally.Tally()
      self.out_data =  {}

   def init(self):
      retval =  True

      self.content_grabber.init()
      self.content_grabber.save(self.out_data)

      self.tally.init()
      self.tally.save(self.out_data)

      return retval

   def load(self):
      retval =  True

      try:
         with open(self.filename) as fd:
            self.out_data =  json.load(fd)
      except json.decoder.JSONDecodeError:
         sys.stderr.write("%s not a json file.\n" % self.filename)
         retval =  False
      except FileNotFoundError:
         sys.stderr.write("file %s not foound.\n" % self.filename)
         retval =  False

      if not self.content_grabber.load(self.out_data):
         sys.stderr.write("json file in %s file does not respect schema.\n" % self.filename)
         retval =  False
   
      if not self.tally.load(self.out_data):
         sys.stderr.write("%s json file does not contain absolute key assigning to dict.\n" % self.filename)
         retval =  False

      return retval

   def load_from_cmdline(self, cmdline_params):
      return self.feed_grabber.load_from_cmdline(cmdline_params)

   def update(self):
      return self.content_grabber.update(self.tally)

   def close(self):
      retval =  True

      self.content_grabber.commit()
      try:
         with open(self.filename, "w") as fd:
            json.dump(self.out_data, fd, indent = 3, sort_keys = True)
      except:
         retval =  False

      return retval
