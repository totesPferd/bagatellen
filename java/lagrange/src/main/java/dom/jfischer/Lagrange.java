package dom.jfischer;

import java.util.HashSet;
import java.util.Set;

class Lagrange implements ILagrange {

   private Set<double[]> knowledge =  new HashSet();

   @Override
   public void learn(Set<double[]> data) {

   }

   @Override
   public double apply(double x) {

      return 0.0;
   }

}
