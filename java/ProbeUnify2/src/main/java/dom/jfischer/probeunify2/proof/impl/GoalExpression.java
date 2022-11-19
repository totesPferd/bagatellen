/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.proof.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.proof.IGoalExpression;
import dom.jfischer.probeunify2.proof.IGoalExtension;
import dom.jfischer.probeunify2.proof.IGoalNonVariableExtension;

/**
 *
 * @author jfischer
 */
public class GoalExpression implements IGoalExpression {

    private final IGoalExtension goalExtension;
    private final IBaseExpression<IGoalNonVariableExtension> goalNonVariableExpression;

    public GoalExpression(IGoalExtension goalExtension, IBaseExpression<IGoalNonVariableExtension> goalNonVariableExpression) {
        this.goalExtension = goalExtension;
        this.goalNonVariableExpression = goalNonVariableExpression;
    }

    @Override
    public void commit() {
        this.goalExtension.commit();
        this.goalNonVariableExpression.commit();
    }

    @Override
    public void reset() {
        this.goalExtension.reset();
        this.goalNonVariableExpression.reset();
    }

    @Override
    public IGoalExtension getExtension() {
        return this.goalExtension;
    }

    @Override
    public IBaseExpression<IGoalNonVariableExtension> getBaseExpression() {
        return this.goalNonVariableExpression;
    }

    @Override
    public String toString() {
        return "GoalExpression{" + "goalExtension=" + goalExtension + ", goalNonVariableExpression=" + goalNonVariableExpression + '}';
    }

}
