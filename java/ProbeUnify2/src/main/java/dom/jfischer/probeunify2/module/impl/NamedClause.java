/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.module.impl;

import dom.jfischer.probeunify2.module.INamedClause;
import dom.jfischer.probeunify2.pel.IPELLeafCollector;
import dom.jfischer.probeunify2.pel.IPELTracker;
import dom.jfischer.probeunify2.pprint.ITermVariableContext;
import dom.jfischer.probeunify2.proof.IClause;

/**
 *
 * @author jfischer
 */
public class NamedClause implements INamedClause {

    private final IClause clause;
    private final ITermVariableContext termVariableContext;

    public NamedClause(IClause clause, ITermVariableContext termVariableContext) {
        this.clause = clause;
        this.termVariableContext = termVariableContext;
    }

    @Override
    public IClause getClause() {
        return this.clause;
    }

    @Override
    public ITermVariableContext getTermVariableContext() {
        return this.termVariableContext;
    }

    @Override
    public void commit() {
        this.clause.commit();
        this.termVariableContext.commit();
    }

    @Override
    public void reset() {
        this.clause.reset();
        this.termVariableContext.reset();
    }

}
