/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ICopy;
import dom.jfischer.probeunify2.basic.ITracker;
import dom.jfischer.probeunify2.pel.IPELLeafCollector;
import dom.jfischer.probeunify2.pel.IPELTracker;
import dom.jfischer.probeunify2.pel.IPredicate;
import dom.jfischer.probeunify2.pel.IPredicateExpression;
import dom.jfischer.probeunify2.basic.ITrivialExtension;

/**
 *
 * @author jfischer
 */
public class PredicateExpressionCopy implements ICopy<IPredicateExpression> {

    private final ICopy<IPredicate> predicateCopy = new PredicateCopy();

    @Override
    public IPredicateExpression copy(IPELTracker tracker, IPredicateExpression object) {
        IPredicate extensionCopy = this.predicateCopy.copy(tracker, object.getExtension());
        ITracker<ITrivialExtension> predicateTracker
                = tracker.getPredicateTracker();
        IBaseExpression<ITrivialExtension> baseExpressionCopy
                = object.getBaseExpression().copy(predicateTracker);
        return new PredicateExpression(extensionCopy, baseExpressionCopy);
    }

    @Override
    public void collectLeafs(IPELLeafCollector leafCollector, IPredicateExpression object) {
    }

}
