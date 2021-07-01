package dom.jfischer;

import java.util.Set;

public interface ILagrange {

   void learn(Set<double[]> data);

   double apply(double x);

}
