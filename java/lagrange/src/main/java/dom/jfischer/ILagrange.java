package dom.jfischer;

import java.util.Set;

/**
 * <p>
 * ILagrange interface.</p>
 *
 * @author jfischer
 * @version $Id: $Id
 */
public interface ILagrange {

    /**
     * <p>
     * learn.</p>
     *
     * @param data a {@link java.util.Set} object.
     */
    void learn(Set<double[]> data);

    /**
     * <p>
     * apply.</p>
     *
     * @param x a double.
     * @return a double.
     */
    double apply(double x);

}
