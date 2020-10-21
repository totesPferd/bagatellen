class ContentGrabber:

   def __init__(self):
      self.grabbers =  []

   def register_grabber(self, grabber):
      self.grabbers.append(grabber)

   def load(self, d):
      grabbers =  self.grabbers.copy()
      for grabber in grabbers:
         if not grabber.load(d):
            self.grabbers.remove(grabber)

      return True

   def save(self, d):
      for grabber in self.grabbers:
         grabber.save(d)

   def load_from_sites_dict(self, d):
      grabbers =  self.grabbers.copy()
      for grabber in grabbers:
         grabber.load_from_sites_dict(d)
         self.grabbers.remove(grabber)

      return True
