class ContentGrabber:

   def __init__(self):
      self.grabbers =  []

   def register_grabber(self, grabber):
      self.grabbers.append(grabber)

   def load(self, d):
      for grabber in self.grabbers:
         grabber.load(d)

   def save(self, d):
      for grabber in self.grabbers:
         grabber.save(d)

   def load_from_sites_dict(self, d):
      for grabber in self.grabbers:
         grabber.load_from_sites_dict(d)
