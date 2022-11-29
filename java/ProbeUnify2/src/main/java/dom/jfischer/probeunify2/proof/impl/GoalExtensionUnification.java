/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.proof.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.IUnification;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.proof.IGoalExtension;

/**
 *
 * @author jfischer
 */
public class GoalExtensionUnification implements
        IUnification<IGoalExtension> {

    private final IUnification<IBaseExpression<ILiteralNonVariableExtension>> unification;

    public GoalExtensionUnification(IUnification<IBaseExpression<ILiteralNonVariableExtension>> unification) {
        this.unification = unification;
    }

    @Override
    public boolean unify(IGoalExtension arg1, IGoalExtension arg2) {
        return this.unification.unify(arg1.getGoal(), arg2.getGoal());
    }

}
