/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.proof.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ICopy;
import dom.jfischer.probeunify2.basic.ILeafCollector;
import dom.jfischer.probeunify2.basic.ITracker;
import dom.jfischer.probeunify2.pel.IPELLeafCollector;
import dom.jfischer.probeunify2.pel.IPELTracker;
import dom.jfischer.probeunify2.proof.IGoalExpression;
import dom.jfischer.probeunify2.proof.IGoalExtension;
import dom.jfischer.probeunify2.proof.IGoalNonVariableExtension;

/**
 *
 * @author jfischer
 */
public class GoalExpressionCopy implements ICopy<IGoalExpression> {

    private final ICopy<IGoalExtension> goalExtensionCopier
            = new GoalExtensionCopy();

    @Override
    public IGoalExpression copy(IPELTracker tracker, IGoalExpression object) {
        IGoalExtension goalExtensionCopy
                = this.goalExtensionCopier.copy(tracker, object.getExtension());
        ITracker<IGoalNonVariableExtension> goalTracker = tracker.getGoalTracker();
        IBaseExpression<IGoalNonVariableExtension> baseExpressionCopy = object.getBaseExpression().copy(goalTracker);
        return new GoalExpression(goalExtensionCopy, baseExpressionCopy);
    }

    @Override
    public void collectLeafs(IPELLeafCollector leafCollector, IGoalExpression object) {
        this.goalExtensionCopier.collectLeafs(leafCollector, object.getExtension());
        {
            ILeafCollector<IGoalNonVariableExtension> moduleLeafCollector
                    = leafCollector.getGoalLeafCollector();
            object.getBaseExpression().collectLeafs(moduleLeafCollector);
        }
    }

}
