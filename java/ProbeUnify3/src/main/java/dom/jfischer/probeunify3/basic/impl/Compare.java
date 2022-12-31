/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify3.basic.impl;

import dom.jfischer.probeunify3.basic.CompareResult;
import dom.jfischer.probeunify3.basic.ICompare;
import dom.jfischer.probeunify3.basic.ICopy;
import dom.jfischer.probeunify3.basic.ILeafCollector;
import dom.jfischer.probeunify3.basic.ITNonVariableXt;
import dom.jfischer.probeunify3.basic.ITracker;
import dom.jfischer.probeunify3.basic.IUnification;
import dom.jfischer.probeunify3.basic.IVariableContext;
import dom.jfischer.probeunify3.basic.IXpr;
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

    private final ICopy<IXpr<ITNonVariableXt>, ITracker<IXpr<ITNonVariableXt>>> copier;
    private final IUnification<IXpr<ITNonVariableXt>> unification;

    public Compare(IVariableContext<ITNonVariableXt> variableContext) {
        TNonVariableXtCopy nonVariableXtCopy
                = new TNonVariableXtCopy(variableContext);
        this.copier = nonVariableXtCopy.getBaseCopier();
        this.unification
                = new XprUnification<>();
    }

    @Override
    public CompareResult compare(
            IXpr<ITNonVariableXt> arg1,
            IXpr<ITNonVariableXt> arg2,
            IXpr<ITNonVariableXt> cmp) {
        CompareResult retval = CompareResult.NEITHER_NOR;

        boolean unifyResult1 = this.unification.unify(arg1, cmp);
        if (unifyResult1) {
            ITracker<IXpr<ITNonVariableXt>> pelTracker1
                    = new Tracker<>();
            IXpr<ITNonVariableXt> cmpCopy1 = this.copier.copy(pelTracker1, cmp);
            cmp.reset();
            ILeafCollector<ITNonVariableXt> leafCollector1
                    = new LeafCollector<>();
            cmpCopy1.collectLeafs(leafCollector1);

            boolean unifyResult2 = this.unification.unify(arg2, cmp);
            if (unifyResult2) {
                ITracker<IXpr<ITNonVariableXt>> pelTracker2
                        = new Tracker<>();
                IXpr<ITNonVariableXt> cmpCopy2 = this.copier.copy(pelTracker2, cmp);
                cmp.reset();
                ILeafCollector<ITNonVariableXt> leafCollector2
                        = new LeafCollector<>();
                cmpCopy2.collectLeafs(leafCollector2);

                boolean unifyResult = this.unification.unify(cmpCopy1, cmpCopy2);
                if (unifyResult) {

                    boolean isLeaf1 = leafCollector1.isLeaf();
                    boolean isLeaf2 = leafCollector2.isLeaf();

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
            Function<U, IXpr<ITNonVariableXt>> f,
            Set<U> candidates,
            IXpr<ITNonVariableXt> cmp) {
        Set<U> emptySet = Collections.synchronizedSet(new HashSet<>());
        return candidates
                .stream()
                .map(u -> Set.of(u))
                .reduce(
                        emptySet,
                        (m, n) -> this.mergeMaximalSets(f, m, n, cmp));
    }

    private Set<U> mergeMaximalSets(
            Function<U, IXpr<ITNonVariableXt>> f,
            Set<U> set1,
            Set<U> set2,
            IXpr<ITNonVariableXt> cmp) {
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
