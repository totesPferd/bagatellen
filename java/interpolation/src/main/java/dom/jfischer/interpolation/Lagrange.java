package dom.jfischer.interpolation;

import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;


class Lagrange implements IInterpolator {


    private Set<double[]> knowledge = null;

    /**
     * {@inheritDoc}
     */
    @Override
    public void learn(Set<double[]> data) {
        this.knowledge = data;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public double apply(double x) {
        return this.knowledge
                .parallelStream()
                .map(u -> singleton(u))
                .reduce(new HashSet<double[]>(), (l, r) -> operation(x, l, r))
                .parallelStream()
                .mapToDouble(p -> p[1])
                .sum();
    }

    private Set<double[]> operation(double x, Set<double[]> left, Set<double[]> right) {
        Set<double[]> leftUpdated = updatePoints(x, left, right);
        Set<double[]> rightUpdated = updatePoints(x, right, left);
        leftUpdated.addAll(rightUpdated);
        return leftUpdated;
    }

    private Set<double[]> singleton(double[] p) {
        Set<double[]> retval = new HashSet<>(1);
        retval.add(p);
        return retval;
    }

    private Set<double[]> updatePoints(double x, Set<double[]> left, Set<double[]> right) {
        return left
                .parallelStream()
                .map(p -> {
                    double[] retval = { p[0],
                            p[1] * right
                                    .parallelStream()
                                    .map(q -> ((double) (x - q[0])) / ((double) (p[0] - q[0])))
                                    .reduce(1.0, (u, v) -> u * v) };
                    return retval;
                })
                .collect(Collectors.toSet());
    }

}
