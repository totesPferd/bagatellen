/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.proof.impl;

import dom.jfischer.probeunify2.basic.IBaseCopy;
import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.IExpression;
import dom.jfischer.probeunify2.basic.ILeafCollector;
import dom.jfischer.probeunify2.basic.ITracker;
import dom.jfischer.probeunify2.basic.impl.Expression;
import dom.jfischer.probeunify2.proof.IGoalExtension;
import dom.jfischer.probeunify2.proof.IGoalNonVariableExtension;

/**
 *
 * @author jfischer
 */
public class GoalExpressionBaseCopy implements
        IBaseCopy<IGoalNonVariableExtension, IExpression<IGoalExtension, IGoalNonVariableExtension>> {

    private final IBaseCopy<IGoalNonVariableExtension, IGoalExtension> goalExtensionBaseCopier;

    public GoalExpressionBaseCopy(IBaseCopy<IGoalNonVariableExtension, IGoalExtension> goalExtensionCopier) {
        this.goalExtensionBaseCopier = goalExtensionCopier;
    }

    @Override
    public IExpression<IGoalExtension, IGoalNonVariableExtension> copy(ITracker<IGoalNonVariableExtension> tracker, IExpression<IGoalExtension, IGoalNonVariableExtension> object) {
        IGoalExtension goalExtensionCopy
                = this.goalExtensionBaseCopier.copy(tracker, object.getExtension());
        IBaseExpression<IGoalNonVariableExtension> baseExpressionCopy
                = object.getBaseExpression().copy(tracker);
        return new Expression<>(goalExtensionCopy, baseExpressionCopy);
    }

    @Override
    public void collectLeafs(ILeafCollector<IGoalNonVariableExtension> leafCollector, IExpression<IGoalExtension, IGoalNonVariableExtension> object) {
        this.goalExtensionBaseCopier.collectLeafs(leafCollector, object.getExtension());
        {
            object.getBaseExpression().collectLeafs(leafCollector);
        }
    }

}
