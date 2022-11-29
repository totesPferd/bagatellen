/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.proof.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.IExpression;
import dom.jfischer.probeunify2.basic.IUnification;
import dom.jfischer.probeunify2.basic.impl.MultiUnification;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.proof.IGoalExtension;
import dom.jfischer.probeunify2.proof.IGoalNonVariableExtension;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 *
 * @author jfischer
 */
public class GoalNonVariableExtensionUnification implements
        IUnification<IGoalNonVariableExtension> {

    private final IUnification<List<IBaseExpression<ILiteralNonVariableExtension>>> unification;

    public GoalNonVariableExtensionUnification(IUnification<IBaseExpression<ILiteralNonVariableExtension>> goalUnification) {
        this.unification = new MultiUnification<>(goalUnification);
    }

    @Override
    public boolean unify(IGoalNonVariableExtension arg1, IGoalNonVariableExtension arg2) {
        List<IBaseExpression<ILiteralNonVariableExtension>> lit1
                = Collections.synchronizedList(arg1.getSubGoals()
                        .parallelStream()
                        .map(IExpression<IGoalExtension, IGoalNonVariableExtension>::getExtension)
                        .map(IGoalExtension::getGoal)
                        .collect(Collectors.toList()));
        List<IBaseExpression<ILiteralNonVariableExtension>> lit2
                = Collections.synchronizedList(arg1.getSubGoals()
                        .parallelStream()
                        .map(IExpression<IGoalExtension, IGoalNonVariableExtension>::getExtension)
                        .map(IGoalExtension::getGoal)
                        .collect(Collectors.toList()));
        return this.unification.unify(lit1, lit2);
    }

}
