/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify3.basic.impl;

import dom.jfischer.probeunify3.basic.IClause;
import dom.jfischer.probeunify3.basic.IGoal;
import dom.jfischer.probeunify3.basic.ITNonVariableXt;
import dom.jfischer.probeunify3.basic.IVariableContext;
import dom.jfischer.probeunify3.basic.IXpr;
import java.util.List;

/**
 *
 * @author jfischer
 */
public class Clause implements IClause {
    private final IVariableContext<ITNonVariableXt> variableContext;
    private final List<IClause> premises;
    private final IXpr<ITNonVariableXt> conclusion;

    public Clause(IGoal goal) {
        this.variableContext = goal.getVariableContext();
        this.premises = goal.getAssumptions().getAssumptions();
        this.conclusion = goal.getConclusion();
    }

    public Clause(IVariableContext<ITNonVariableXt> variableContext, List<IClause> premises, IXpr<ITNonVariableXt> conclusion) {
        this.variableContext = variableContext;
        this.premises = premises;
        this.conclusion = conclusion;
    }

    @Override
    public IVariableContext<ITNonVariableXt> getVariableContext() {
        return this.variableContext;
    }

    @Override
    public List<IClause> getPremises() {
        return this.premises;
    }

    @Override
    public IXpr<ITNonVariableXt> getConclusion() {
        return this.conclusion;
    }

    @Override
    public void commit() {
        this.conclusion.commit();
        this.premises
                .parallelStream()
                .forEach(premis -> premis.commit());
    }

    @Override
    public void reset() {
        this.conclusion.reset();
        this.premises
                .parallelStream()
                .forEach(premis -> premis.reset());
    }

}
