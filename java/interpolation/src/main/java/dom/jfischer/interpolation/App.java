package dom.jfischer.interpolation;

import java.util.HashSet;
import java.util.Set;

/**
 * Hello world!
 *
 * @author jfischer
 * @version $Id: $Id
 */
public class App {

    /**
     * <p>
     * main.</p>
     *
     * @param args an array of {@link java.lang.String} objects.
     */
    public static void main(String[] args) {
        IInterpolator interpolator = new Newton();

        Set<double[]> points = new HashSet(2);

        double[] p_1 = {2.0, 5.0};
        double[] p_2 = {3.0, 7.0};

        points.add(p_1);
        points.add(p_2);

        interpolator.learn(points);

        double y_1 = interpolator.apply(2.0);
        double y_2 = interpolator.apply(3.0);

        System.out.println("y_1 = " + y_1 + ", y_2 = " + y_2);

        double[] p_3 = {5.0, 12.0};

        points.add(p_3);

        interpolator.learn(points);

        y_1 = interpolator.apply(2.0);
        y_2 = interpolator.apply(3.0);
        double y_3 = interpolator.apply(5.0);
        double y_4 = interpolator.apply(7.0);

        System.out.println("y_1 = " + y_1 + ", y_2 = " + y_2 + ", y_3 = " + y_3 + ", y_4 = " + y_4);

    }
}
