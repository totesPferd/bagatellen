/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.basic.impl;

import dom.jfischer.probeunify2.basic.CompareResult;
import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ICompare;
import dom.jfischer.probeunify2.basic.ICopy;
import dom.jfischer.probeunify2.basic.IUnification;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.IPELLeafCollector;
import dom.jfischer.probeunify2.pel.IPELTracker;
import dom.jfischer.probeunify2.pel.impl.PELLeafCollector;
import dom.jfischer.probeunify2.pel.impl.PELTracker;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import java.util.function.Function;

/**
 *
 * @author jfischer
 * @param <U>
 */
public class Compare<U> implements ICompare<U> {

    private final ICopy<IBaseExpression<ILiteralNonVariableExtension>> copier;
    private final IUnification<IBaseExpression<ILiteralNonVariableExtension>> unification;

    public Compare(ICopy<IBaseExpression<ILiteralNonVariableExtension>> copier, IUnification<IBaseExpression<ILiteralNonVariableExtension>> unification) {
        this.copier = copier;
        this.unification = unification;
    }

    @Override
    public CompareResult compare(
            IBaseExpression<ILiteralNonVariableExtension> arg1,
            IBaseExpression<ILiteralNonVariableExtension> arg2,
            IBaseExpression<ILiteralNonVariableExtension> cmp) {
        CompareResult retval = CompareResult.NEITHER_NOR;

        boolean unifyResult1 = this.unification.unify(arg1, cmp);
        if (unifyResult1) {
            IPELTracker pelTracker1 = new PELTracker();
            IBaseExpression<ILiteralNonVariableExtension> cmpCopy1 = this.copier.copy(pelTracker1, cmp);
            cmp.reset();
            IPELLeafCollector leafCollector1 = new PELLeafCollector();
            this.copier.collectLeafs(leafCollector1, cmpCopy1);

            boolean unifyResult2 = this.unification.unify(arg2, cmp);
            if (unifyResult2) {
                IPELTracker pelTracker2 = new PELTracker();
                IBaseExpression<ILiteralNonVariableExtension> cmpCopy2 = this.copier.copy(pelTracker2, cmp);
                cmp.reset();
                IPELLeafCollector leafCollector2 = new PELLeafCollector();
                this.copier.collectLeafs(leafCollector2, cmpCopy2);

                boolean unifyResult = this.unification.unify(cmpCopy1, cmpCopy2);
                if (unifyResult) {

                    boolean isLeaf1 = leafCollector1.getTermLeafCollector().isLeaf();
                    boolean isLeaf2 = leafCollector2.getTermLeafCollector().isLeaf();

                    if (isLeaf1 && isLeaf2) {
                        retval = CompareResult.EQUAL;
                    } else if (isLeaf1) {
                        retval = CompareResult.GREATER_THAN;
                    } else if (isLeaf2) {
                        retval = CompareResult.LESS_THAN;
                    }
                }
            }
        }

        return retval;
    }

    @Override
    public Set<U> getMaximalSet(
            Function<U, IBaseExpression<ILiteralNonVariableExtension>> f,
            Set<U> candidates,
            IBaseExpression<ILiteralNonVariableExtension> cmp) {
        Set<U> emptySet = Collections.synchronizedSet(new HashSet<>());
        return candidates
                .stream()
                .map(u -> Set.of(u))
                .reduce(
                        emptySet,
                        (m, n) -> this.mergeMaximalSets(f, m, n, cmp));
    }

    private Set<U> mergeMaximalSets(
            Function<U, IBaseExpression<ILiteralNonVariableExtension>> f,
            Set<U> set1,
            Set<U> set2,
            IBaseExpression<ILiteralNonVariableExtension> cmp) {
        Set<U> setCopy1 = Collections.synchronizedSet(new HashSet<>());
        setCopy1.addAll(set1);
        Set<U> setCopy2 = Collections.synchronizedSet(new HashSet<>());
        setCopy2.addAll(set2);

        for (U expr1 : set1) {
            for (U expr2 : set2) {
                CompareResult cmpResult = this.compare(f.apply(expr1), f.apply(expr2), cmp);
                if (cmpResult == CompareResult.GREATER_THAN
                        || cmpResult == CompareResult.EQUAL) {
                    setCopy1.remove(expr1);
                } else if (cmpResult == CompareResult.LESS_THAN) {
                    setCopy2.remove(expr2);
                }
            }
        }

        Set<U> retval = Collections.synchronizedSet(new HashSet<>());
        retval.addAll(setCopy1);
        retval.addAll(setCopy2);
        return retval;
    }

}
