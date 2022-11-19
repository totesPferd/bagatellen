/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ICopy;
import dom.jfischer.probeunify2.basic.ITracker;
import dom.jfischer.probeunify2.pel.IOperation;
import dom.jfischer.probeunify2.pel.IOperationExpression;
import dom.jfischer.probeunify2.pel.IPELLeafCollector;
import dom.jfischer.probeunify2.pel.IPELTracker;
import dom.jfischer.probeunify2.basic.ITrivialExtension;

/**
 *
 * @author jfischer
 */
public class OperationExpressionCopy implements ICopy<IOperationExpression> {

    private final ICopy<IOperation> operationCopy = new OperationCopy();

    @Override
    public IOperationExpression copy(IPELTracker tracker, IOperationExpression object) {
        IOperation extensionCopy = this.operationCopy.copy(tracker, object.getExtension());
        ITracker<ITrivialExtension> operationTracker = tracker.getOperationTracker();
        IBaseExpression<ITrivialExtension> baseExpressionCopy
                = object.getBaseExpression().copy(operationTracker);
        return new OperationExpression(extensionCopy, baseExpressionCopy);
    }

    @Override
    public void collectLeafs(IPELLeafCollector leafCollector, IOperationExpression object) {
    }

}
