/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.proof.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ICopy;
import dom.jfischer.probeunify2.basic.ILeafCollector;
import dom.jfischer.probeunify2.basic.ITracker;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.IPELLeafCollector;
import dom.jfischer.probeunify2.pel.IPELTracker;
import dom.jfischer.probeunify2.proof.IGoalExtension;

/**
 *
 * @author jfischer
 */
public class GoalExtensionCopy implements ICopy<IGoalExtension> {

    @Override
    public IGoalExtension copy(IPELTracker tracker, IGoalExtension object) {
        ITracker<ILiteralNonVariableExtension> literalTracker
                = tracker.getLiteralTracker();
        IBaseExpression<ILiteralNonVariableExtension> goalCopy
                = object.getGoal().copy(literalTracker);
        return new GoalExtension(goalCopy);
    }

    @Override
    public void collectLeafs(IPELLeafCollector leafCollector, IGoalExtension object) {
        ILeafCollector<ILiteralNonVariableExtension> literalLeafCollector
                = leafCollector.getLiteralLeafCollector();
        object.getGoal().collectLeafs(literalLeafCollector);
    }

}
