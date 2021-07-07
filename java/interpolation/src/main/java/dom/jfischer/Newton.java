package dom.jfischer;

import java.util.Set;


class Newton implements IInterpolator {

   private double xVec[] =  null;
   private double triangle[] =  null;

   @Override
   public void learn(Set<double[]> data) {
      int length =  data.size();

      this.xVec =  new double[length];
      this.triangle =  new double[linPartialSum(length)];

      {
         int j =  0;
         for (double p[]: data) {
            this.xVec[j] =  p[0];
            set(0, j, p[1]);
            j++;
         }
      }

      for (int k =  1; k < length; k++) {
         for (int i =  0; i < k; i++) {
            for (int j =  0; j < k - i; j++) {
               double value =  (get(i, j + 1) - get(i, j)) / (this.xVec[i + j + 1] - this.xVec[j]);
               if (
                     Double.isNaN(value)
                  || value == Double.POSITIVE_INFINITY
                  || value == Double.NEGATIVE_INFINITY ) {
                  set(i + 1, j, 0.0);
                  int n =  j;
                  for (int m =  i; m >= 0; m--) {
                     set(
                           m
                        ,  n + 1
                        ,
                                 get(m, n)
                              +
                                       (this.xVec[m + n] - this.xVec[m])
                                    *  get(m + 1, n) );
                     n++;
                  }
               } else {
                  set(i + 1, j, value);
               }
            }
         }
      }

   }

   @Override
   public double apply(double x) {
      double retval =  0.0;
      int length =  this.xVec.length;

      for (int m =  length - 1; m >= 0; m--) {
         int n =  length - m - 1;
         retval =
               get(m, n)
            +                          (x - this.xVec[n])
                                    *  retval;

      }

      return retval;
   }

   private double get(int i, int j) {
      return this.triangle[cantorIndex(i, j)];
   }

   private void set(int i, int j, double x) {
      this.triangle[cantorIndex(i, j)] =  x;
   }

   private int cantorIndex(int i, int j) {
      return linPartialSum(i + j) + j;
   }

   private int linPartialSum(int m) {
      return (m * (m + 1)) / 2;
   }

}
