package dom.jfischer.interpolation;

public class LagrangeTest extends IInterpolatorTest {

   @Override
   protected IInterpolator getObject() {
      return new Lagrange();
   }

}
