/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ICopy;
import dom.jfischer.probeunify2.basic.ITracker;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.pel.IPELLeafCollector;
import dom.jfischer.probeunify2.pel.IPELTracker;
import dom.jfischer.probeunify2.pel.IPredicate;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 *
 * @author jfischer
 */
public class PredicateCopy implements ICopy<IPredicate> {

    @Override
    public IPredicate copy(IPELTracker tracker, IPredicate object) {
        ITracker<ITrivialExtension> sortTracker = tracker.getSortTracker();
        List<IBaseExpression<ITrivialExtension>> domainCopy
                = Collections.synchronizedList(object.getDomain()
                        .stream()
                        .map(sortExpr -> sortExpr.copy(sortTracker))
                        .collect(Collectors.toList()));
        return new Predicate(domainCopy);
    }

    @Override
    public void collectLeafs(IPELLeafCollector leafCollector, IPredicate object) {
    }

}
