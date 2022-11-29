/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ICopy;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.IPELLeafCollector;
import dom.jfischer.probeunify2.pel.IPELTracker;

/**
 *
 * @author jfischer
 */
public class LiteralCopy implements ICopy<IBaseExpression<ILiteralNonVariableExtension>> {

    @Override
    public IBaseExpression<ILiteralNonVariableExtension> copy(IPELTracker tracker, IBaseExpression<ILiteralNonVariableExtension> object) {
        return object.copy(tracker.getLiteralTracker());
    }

    @Override
    public void collectLeafs(IPELLeafCollector leafCollector, IBaseExpression<ILiteralNonVariableExtension> object) {
        object.collectLeafs(leafCollector.getLiteralLeafCollector());
    }

}
