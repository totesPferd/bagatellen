package dom.jfischer;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

class Lagrange implements ILagrange {

    private Set<double[]> knowledge = null;

    /**
     * {@inheritDoc}
     */
    @Override
    public void learn(Set<double[]> data) {
        this.knowledge = data
                .parallelStream()
                .map((p) -> singleton(p))
                .reduce(new HashSet(), (u, v) -> operation(u, v));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public double apply(double x) {
        return this.knowledge
                .parallelStream()
                .mapToDouble(p
                        -> p[1]
                * this.knowledge
                        .parallelStream()
                        .filter(q -> p != q)
                        .mapToDouble(q -> x - q[0])
                        .reduce(1.0, (u, v) -> u * v))
                .sum();
    }

    private Set<double[]> operation(Set<double[]> left, Set<double[]> right) {
        Set<double[]> leftUpdated = updatePoints(left, right);
        Set<double[]> rightUpdated = updatePoints(right, left);
        leftUpdated.addAll(rightUpdated);
        return leftUpdated;
    }

    private Set<double[]> singleton(double[] p) {
        Set<double[]> retval = new HashSet(1);
        retval.add(p);
        return retval;
    }

    private Set<double[]> updatePoints(Set<double[]> left, Set<double[]> right) {
        return left
                .parallelStream()
                .map(p -> {
                    double retval[] = {
                        p[0],
                        p[1]
                        / right
                        .parallelStream()
                        .map(q -> (p[0] - q[0]))
                        .reduce(1.0, (x, y) -> x * y)};
                    return retval;
                })
                .collect(Collectors.toSet());
    }

}
