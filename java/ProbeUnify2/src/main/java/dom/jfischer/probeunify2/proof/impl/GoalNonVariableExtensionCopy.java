/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.proof.impl;

import dom.jfischer.probeunify2.basic.ICopy;
import dom.jfischer.probeunify2.pel.IPELLeafCollector;
import dom.jfischer.probeunify2.pel.IPELTracker;
import dom.jfischer.probeunify2.proof.IGoalExpression;
import dom.jfischer.probeunify2.proof.IGoalNonVariableExtension;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 *
 * @author jfischer
 */
public class GoalNonVariableExtensionCopy implements ICopy<IGoalNonVariableExtension> {

    private final ICopy<IGoalExpression> goalExpressionCopier
            = new GoalExpressionCopy();

    @Override
    public IGoalNonVariableExtension copy(IPELTracker tracker, IGoalNonVariableExtension object) {
        List<IGoalExpression> resultList
                = Collections.synchronizedList(object.getSubGoals()
                        .stream()
                        .map(goal -> this.goalExpressionCopier.copy(tracker, goal))
                        .collect(Collectors.toList()));
        return new GoalNonVariableExtension(resultList);
    }

    @Override
    public void collectLeafs(IPELLeafCollector leafCollector, IGoalNonVariableExtension object) {
        object.getSubGoals()
                .parallelStream()
                .forEach(goal -> this.goalExpressionCopier.collectLeafs(leafCollector, goal));
    }

}
