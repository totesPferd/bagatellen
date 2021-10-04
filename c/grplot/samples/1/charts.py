import math

def chartA():
   w =  100.0
   radius =  0.0004

   index =  0

   a =  0
   while (a < 2.0 * math.pi):
      x =  0.3 * math.sin(a) + 0.5
      y =  0.3 * math.cos(a) + 0.5

      print(0, 0, index, x, y, w, radius)
      a += 0.01


def chartB():
   w =  100.0
   radius =  0.0004

   index =  1

   a =  0.1
   while (a < 0.9):
      x =  a
      y =  a

      print(0, 0, index, x, y, w, radius)
      a += 0.01


def chartC():
   w =  100.0
   radius =  0.0004

   index =  2

   a =  0.1
   while (a < 0.9):
      x =  a
      y =  1.0 - a

      print(0, 0, index, x, y, w, radius)
      a += 0.01


chartA()
chartB()
chartC()
