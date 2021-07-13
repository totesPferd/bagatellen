package dom.jfischer.interpolation;

public class AnotherLagrangeTest extends IInterpolatorTest {

   @Override
   protected IInterpolator getObject() {
      return new AnotherLagrange();
   }

}
