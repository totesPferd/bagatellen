/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.proof.impl;

import dom.jfischer.probeunify2.basic.IBaseCopy;
import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ILeafCollector;
import dom.jfischer.probeunify2.basic.ITracker;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.proof.IGoalExtension;
import dom.jfischer.probeunify2.proof.IGoalNonVariableExtension;

/**
 *
 * @author jfischer
 */
public class GoalExtensionBaseCopy implements
        IBaseCopy<IGoalNonVariableExtension, IGoalExtension> {

    private final IBaseCopy<IGoalNonVariableExtension, IBaseExpression<ILiteralNonVariableExtension>> copier;

    public GoalExtensionBaseCopy(IBaseCopy<IGoalNonVariableExtension, IBaseExpression<ILiteralNonVariableExtension>> copier) {
        this.copier = copier;
    }

    @Override
    public IGoalExtension copy(ITracker<IGoalNonVariableExtension> tracker, IGoalExtension object) {
        IBaseExpression<ILiteralNonVariableExtension> goalCopy = this.copier.copy(tracker, object.getGoal());
        return new GoalExtension(goalCopy);
    }

    @Override
    public void collectLeafs(ILeafCollector<IGoalNonVariableExtension> leafCollector, IGoalExtension object) {
        this.copier.collectLeafs(leafCollector, object.getGoal());
    }

}
