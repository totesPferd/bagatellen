/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.proof.impl;

import dom.jfischer.probeunify2.basic.ICheckVariableOccurence;
import dom.jfischer.probeunify2.basic.IVariable;
import dom.jfischer.probeunify2.proof.IGoalNonVariableExtension;

/**
 *
 * @author jfischer
 */
public class GoalNonVariableExtensionVariableOccurenceChecker implements
        ICheckVariableOccurence<IGoalNonVariableExtension> {

    @Override
    public boolean containsVariable(IGoalNonVariableExtension object, IVariable<IGoalNonVariableExtension> variable) {
        return object.getSubGoals()
                .parallelStream()
                .anyMatch(goalExpr -> goalExpr.getBaseExpression().containsVariable(variable));
    }

}
