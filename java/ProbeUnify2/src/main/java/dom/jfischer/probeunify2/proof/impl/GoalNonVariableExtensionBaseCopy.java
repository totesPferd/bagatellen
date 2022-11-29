/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.proof.impl;

import dom.jfischer.probeunify2.basic.IBaseCopy;
import dom.jfischer.probeunify2.basic.IExpression;
import dom.jfischer.probeunify2.basic.ILeafCollector;
import dom.jfischer.probeunify2.basic.ITracker;
import dom.jfischer.probeunify2.proof.IGoalExtension;
import dom.jfischer.probeunify2.proof.IGoalNonVariableExtension;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 *
 * @author jfischer
 */
public class GoalNonVariableExtensionBaseCopy implements
        IBaseCopy<IGoalNonVariableExtension, IGoalNonVariableExtension> {

    private final IBaseCopy<IGoalNonVariableExtension, IExpression<IGoalExtension, IGoalNonVariableExtension>> goalExpressionBaseCopier;

    public GoalNonVariableExtensionBaseCopy(IBaseCopy<IGoalNonVariableExtension, IExpression<IGoalExtension, IGoalNonVariableExtension>> goalExpressionBaseCopier) {
        this.goalExpressionBaseCopier = goalExpressionBaseCopier;
    }

    @Override
    public IGoalNonVariableExtension copy(ITracker<IGoalNonVariableExtension> tracker, IGoalNonVariableExtension object) {
        List<IExpression<IGoalExtension, IGoalNonVariableExtension>> resultList
                = Collections.synchronizedList(object.getSubGoals()
                        .stream()
                        .map(goal -> this.goalExpressionBaseCopier.copy(tracker, goal))
                        .collect(Collectors.toList()));
        return new GoalNonVariableExtension(resultList);
    }

    @Override
    public void collectLeafs(ILeafCollector<IGoalNonVariableExtension> leafCollector, IGoalNonVariableExtension object) {
        object.getSubGoals()
                .parallelStream()
                .forEach(goal -> this.goalExpressionBaseCopier.collectLeafs(leafCollector, goal));
    }

}
