/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.pel.IOperationExpression;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import java.util.List;

/**
 *
 * @author jfischer
 */
public class TermNonVariableExtension implements ITermNonVariableExtension {

    private final IOperationExpression operation;
    private final List<IBaseExpression<ITermNonVariableExtension>> arguments;

    public TermNonVariableExtension(IOperationExpression operation, List<IBaseExpression<ITermNonVariableExtension>> arguments) {
        this.operation = operation;
        this.arguments = arguments;
    }

    @Override
    public IOperationExpression getOperation() {
        return this.operation;
    }

    @Override
    public void commit() {
        this.arguments
                .stream()
                .forEach(term -> term.commit());
    }

    @Override
    public void reset() {
        this.arguments
                .stream()
                .forEach(term -> term.reset());
    }

    @Override
    public List<IBaseExpression<ITermNonVariableExtension>> getArguments() {
        return this.arguments;
    }

    @Override
    public String toString() {
        return "TermNonVariableExtension{" + "operation=" + operation + ", arguments=" + arguments + '}';
    }

}
