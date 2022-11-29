/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.INonVariable;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.basic.IVariable;
import dom.jfischer.probeunify2.pel.INamedTerm;
import dom.jfischer.probeunify2.pel.ITermExtension;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import java.util.Optional;
import dom.jfischer.probeunify2.basic.IVariableContext;

/**
 *
 * @author jfischer
 */
public class NamedTerm implements INamedTerm {

    private final IBaseExpression<ITermNonVariableExtension> term;
    private final IVariableContext<ITermExtension, ITermNonVariableExtension> termVariableContext;

    public NamedTerm(IBaseExpression<ITermNonVariableExtension> term, IVariableContext<ITermExtension, ITermNonVariableExtension> termVariableContext) {
        this.term = term;
        this.termVariableContext = termVariableContext;
    }

    @Override
    public IBaseExpression<ITermNonVariableExtension> getTerm() {
        return this.term;
    }

    @Override
    public IVariableContext<ITermExtension, ITermNonVariableExtension> getTermVariableContext() {
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
    public ITermExtension getExtension() {
        ITermExtension retval = null;

        {
            Optional<INonVariable<ITermNonVariableExtension>> optNonVariable
                    = this.term.nonVariable();
            if (optNonVariable.isPresent()) {
                INonVariable<ITermNonVariableExtension> nonVariable
                        = optNonVariable.get();
                IBaseExpression<ITrivialExtension> sort = nonVariable
                        .getNonVariableExtension()
                        .getOperation()
                        .getExtension()
                        .getRange();
                retval = new TermExtension(sort);
            }
        }
        {
            Optional<IVariable<ITermNonVariableExtension>> optVariable
                    = this.term.variable();
            if (optVariable.isPresent()) {
                IVariable<ITermNonVariableExtension> variable
                        = optVariable.get();
                retval = this.termVariableContext.getExtensionMap().get(variable);
            }
        }

        return retval;
    }

    @Override
    public IBaseExpression<ITermNonVariableExtension> getBaseExpression() {
        return this.term;
    }

}
