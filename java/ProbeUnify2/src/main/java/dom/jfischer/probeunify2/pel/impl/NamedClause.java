/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.pel.INamedClause;
import dom.jfischer.probeunify2.pel.INamedLiteral;
import dom.jfischer.probeunify2.pel.IPELVariableContext;
import dom.jfischer.probeunify2.proof.IClause;

/**
 *
 * @author jfischer
 */
public class NamedClause implements INamedClause {

    private final IClause clause;
    private final IPELVariableContext pelVariableContext;

    public NamedClause(IClause clause, IPELVariableContext pelVariableContext) {
        this.clause = clause;
        this.pelVariableContext = pelVariableContext;
    }

    @Override
    public IClause getClause() {
        return this.clause;
    }

    @Override
    public void commit() {
        this.clause.commit();
        this.pelVariableContext.commit();
    }

    @Override
    public void reset() {
        this.clause.reset();
        this.pelVariableContext.reset();
    }

    @Override
    public IPELVariableContext getPelVariableContext() {
        return this.pelVariableContext;
    }

    @Override
    public boolean isFree() {
        INamedLiteral namedConclusion
                = new NamedLiteral(this.clause.getConclusion(), this.pelVariableContext);
        boolean retval = namedConclusion.isFree();

        if (retval) {
            retval = this.clause.getPremises()
                    .parallelStream()
                    .map(premis -> new NamedLiteral(premis, this.pelVariableContext))
                    .allMatch(namedPremis -> namedPremis.isFree());
        }

        return retval;
    }

}
