/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2;

import dom.jfischer.probeunify2.basic.IExpression;
import dom.jfischer.probeunify2.basic.IVariable;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import dom.jfischer.probeunify2.proof.IGoalExtension;
import dom.jfischer.probeunify2.proof.IGoalNonVariableExtension;
import java.util.List;
import java.util.Set;

/**
 *
 * @author jfischer
 */
public class ProofStep implements IProofStep {

    private final Set<IVariable<ITermNonVariableExtension>> termVariables;
    private final List<IExpression<IGoalExtension, IGoalNonVariableExtension>> goals;

    public ProofStep(Set<IVariable<ITermNonVariableExtension>> termVariables, List<IExpression<IGoalExtension, IGoalNonVariableExtension>> goals) {
        this.termVariables = termVariables;
        this.goals = goals;
    }

    @Override
    public Set<IVariable<ITermNonVariableExtension>> getTermVariables() {
        return this.termVariables;
    }

    @Override
    public List<IExpression<IGoalExtension, IGoalNonVariableExtension>> getGoals() {
        return this.goals;
    }

    @Override
    public void reset() {
        this.termVariables
                .parallelStream()
                .forEach(var -> var.clear());
        this.goals
                .parallelStream()
                .forEach(goal -> goal.getExtension().undo());
        this.goals
                .parallelStream()
                .map(goal -> goal.getBaseExpression().variable())
                .filter(optGoalVar -> optGoalVar.isPresent())
                .map(optGoalVar -> optGoalVar.get())
                .forEach(var -> var.clear());
    }

}
