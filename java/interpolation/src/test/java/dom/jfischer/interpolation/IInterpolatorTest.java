package dom.jfischer.interpolation;

import static org.junit.Assert.assertTrue;

import java.util.HashSet;
import java.util.Set;
import org.junit.Test;

public abstract class IInterpolatorTest {

   private static final double EPSILON = 1e12;

   protected abstract IInterpolator getObject();

   @Test
   public void testIncidence() {
        IInterpolator interpolator =  getObject();

        Set<double[]> points = new HashSet(2);

        double[] p_1 = {2.0, 5.0};
        double[] p_2 = {3.0, 7.0};
        double[] p_3 = {5.0, 12.0};

        points.add(p_1);
        points.add(p_2);
        points.add(p_3);

        interpolator.learn(points);

        double y_1 = interpolator.apply(2.0);
        double y_2 = interpolator.apply(3.0);
        double y_3 = interpolator.apply(5.0);

        assertTrue(estimatedlyEquals(y_1, 5.0));
        assertTrue(estimatedlyEquals(y_2, 7.0));
        assertTrue(estimatedlyEquals(y_3, 12.0));
   }

   private boolean estimatedlyEquals(double x, double y) {
      return Math.pow(x - y, 2) < EPSILON;
   }
}
