/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.proof.impl;

import dom.jfischer.probeunify2.basic.IExpression;
import dom.jfischer.probeunify2.proof.IGoalExpression;
import dom.jfischer.probeunify2.proof.IGoalExtension;
import dom.jfischer.probeunify2.proof.IGoalNonVariableExtension;
import java.util.List;

/**
 *
 * @author jfischer
 */
public class GoalNonVariableExtension implements
        IGoalNonVariableExtension {

    private final List<IGoalExpression> subGoals;

    public GoalNonVariableExtension(List<IGoalExpression> subGoals) {
        this.subGoals = subGoals;
    }

    @Override
    public List<IGoalExpression> getSubGoals() {
        return this.subGoals;
    }

    @Override
    public void commit() {
        this.subGoals
                .stream()
                .forEach(IExpression<IGoalExtension, IGoalNonVariableExtension>::commit);
    }

    @Override
    public void reset() {
        this.subGoals
                .stream()
                .forEach(IExpression<IGoalExtension, IGoalNonVariableExtension>::reset);
    }

    @Override
    public String toString() {
        return "GoalNonVariableExtension{" + "subGoals=" + subGoals + '}';
    }

}
