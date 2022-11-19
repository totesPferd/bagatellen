/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.module.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.INonVariable;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.basic.IVariable;
import dom.jfischer.probeunify2.module.INamedTerm;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import dom.jfischer.probeunify2.pprint.ITermVariableContext;
import java.util.Optional;

/**
 *
 * @author jfischer
 */
public class NamedTerm implements INamedTerm {

    private final IBaseExpression<ITermNonVariableExtension> term;
    private final ITermVariableContext termVariableContext;

    public NamedTerm(IBaseExpression<ITermNonVariableExtension> term, ITermVariableContext termVariableContext) {
        this.term = term;
        this.termVariableContext = termVariableContext;
    }

    @Override
    public IBaseExpression<ITermNonVariableExtension> getTerm() {
        return this.term;
    }

    @Override
    public ITermVariableContext getTermVariableContext() {
        return this.termVariableContext;
    }

    @Override
    public void commit() {
        this.term.commit();
        this.termVariableContext.commit();
    }

    @Override
    public void reset() {
        this.term.reset();
        this.termVariableContext.reset();
    }

    @Override
    public IBaseExpression<ITrivialExtension> getSort() {
        IBaseExpression<ITrivialExtension> retval = null;

        {
            Optional<INonVariable<ITermNonVariableExtension>> optNonVariable
                    = this.term.nonVariable();
            if (optNonVariable.isPresent()) {
                INonVariable<ITermNonVariableExtension> nonVariable
                        = optNonVariable.get();
                retval = nonVariable
                        .getNonVariableExtension()
                        .getOperation()
                        .getExtension()
                        .getRange();
            }
        }
        {
            Optional<IVariable<ITermNonVariableExtension>> optVariable
                    = this.term.variable();
            if (optVariable.isPresent()) {
                IVariable<ITermNonVariableExtension> variable
                        = optVariable.get();
                retval = this.termVariableContext.getSortMap().get(variable);
            }
        }

        return retval;
    }

}
