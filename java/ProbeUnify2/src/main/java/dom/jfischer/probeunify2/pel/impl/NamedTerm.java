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
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import java.util.Optional;
import dom.jfischer.probeunify2.basic.IVariableContext;
import java.util.List;

/**
 *
 * @author jfischer
 */
public class NamedTerm implements INamedTerm {

    private final IBaseExpression<ITermNonVariableExtension> term;
    private final IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension> termVariableContext;

    public NamedTerm(IBaseExpression<ITermNonVariableExtension> term, IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension> termVariableContext) {
        this.term = term;
        this.termVariableContext = termVariableContext;
    }

    @Override
    public IBaseExpression<ITermNonVariableExtension> getTerm() {
        return this.term;
    }

    @Override
    public IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension> getTermVariableContext() {
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
    public IBaseExpression<ITrivialExtension> getExtension() {
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
                retval = this.termVariableContext.getExtensionMap().get(variable);
            }
        }

        return retval;
    }

    @Override
    public IBaseExpression<ITermNonVariableExtension> getBaseExpression() {
        return this.term;
    }

    @Override
    public boolean isFree() {
        boolean retval = true;
        IBaseExpression<ITermNonVariableExtension> actualTerm
                = this.term.dereference();
        {
            Optional<INonVariable<ITermNonVariableExtension>> optNonVariableTerm
                    = actualTerm.nonVariable();
            if (optNonVariableTerm.isPresent()) {
                INonVariable<ITermNonVariableExtension> nonVariableTerm
                        = optNonVariableTerm.get();
                List<IBaseExpression<ITermNonVariableExtension>> arguments
                        = nonVariableTerm.getNonVariableExtension().getArguments();
                retval = arguments
                        .parallelStream()
                        .map(t -> new NamedTerm(t, this.termVariableContext))
                        .allMatch(namedTerm -> namedTerm.isFree());
            }
        }
        {
            Optional<IVariable<ITermNonVariableExtension>> optVariableTerm
                    = actualTerm.variable();
            if (optVariableTerm.isPresent()) {
                IVariable<ITermNonVariableExtension> variableTerm
                        = optVariableTerm.get();
                retval = this.termVariableContext.isFree(variableTerm);
            }
        }
        return retval;
    }

}
