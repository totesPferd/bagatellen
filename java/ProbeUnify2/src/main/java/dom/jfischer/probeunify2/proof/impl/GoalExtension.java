/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.proof.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.proof.IGoalExtension;

/**
 *
 * @author jfischer
 */
public class GoalExtension implements
        IGoalExtension {

    private final IBaseExpression<ILiteralNonVariableExtension> goal;

    private boolean isClosedFlag = false;

    public GoalExtension(IBaseExpression<ILiteralNonVariableExtension> goal) {
        this.goal = goal;
    }

    @Override
    public IBaseExpression<ILiteralNonVariableExtension> getGoal() {
        return this.goal;
    }

    @Override
    public void commit() {
        this.goal.commit();
    }

    @Override
    public void reset() {
        this.goal.reset();
    }

    @Override
    public boolean isClosed() {
        return this.isClosedFlag;
    }

    @Override
    public void close() {
        this.isClosedFlag = true;
    }

    @Override
    public void undo() {
        this.isClosedFlag = false;
    }

    @Override
    public String toString() {
        return "GoalExtension{" + "goal=" + goal + ", isClosedFlag=" + isClosedFlag + '}';
    }

}
