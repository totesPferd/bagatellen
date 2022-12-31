/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify3.basic.impl;

import dom.jfischer.probeunify3.basic.IGoal;
import dom.jfischer.probeunify3.basic.IProofStep;
import dom.jfischer.probeunify3.basic.ITNonVariableXt;
import dom.jfischer.probeunify3.basic.IVariable;
import java.util.Set;

/**
 *
 * @author jfischer
 */
public class ProofStep implements IProofStep {

    private final Set<IGoal> openGoals;
    private final Set<IVariable<ITNonVariableXt>> variables;

    public ProofStep(Set<IGoal> openGoals, Set<IVariable<ITNonVariableXt>> variables) {
        this.openGoals = openGoals;
        this.variables = variables;
    }
    
    @Override
    public Set<IGoal> getOpenGoals() {
        return this.openGoals;
    }

    @Override
    public Set<IVariable<ITNonVariableXt>> getVariables() {
        return this.variables;
    }

    @Override
    public void reset() {
        this.openGoals
                .parallelStream()
                .forEach(goal -> goal.clear());
        this.variables
                .parallelStream()
                .forEach(var -> var.clear());
    }
    
}
