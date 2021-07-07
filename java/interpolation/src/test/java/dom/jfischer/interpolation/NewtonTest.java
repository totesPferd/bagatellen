package dom.jfischer.interpolation;

public class NewtonTest extends IInterpolatorTest {

   @Override
   protected IInterpolator getObject() {
      return new Newton();
   }

}
