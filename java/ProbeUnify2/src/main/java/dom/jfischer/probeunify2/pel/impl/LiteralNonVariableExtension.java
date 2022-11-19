/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.IPredicateExpression;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import java.util.List;

/**
 *
 * @author jfischer
 */
public class LiteralNonVariableExtension implements ILiteralNonVariableExtension {

    private final IPredicateExpression predicate;
    private final List<IBaseExpression<ITermNonVariableExtension>> arguments;

    public LiteralNonVariableExtension(IPredicateExpression predicate, List<IBaseExpression<ITermNonVariableExtension>> arguments) {
        this.predicate = predicate;
        this.arguments = arguments;
    }

    @Override
    public IPredicateExpression getPredicate() {
        return this.predicate;
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
        return "LiteralNonVariableExtension{" + "predicate=" + predicate + ", arguments=" + arguments + '}';
    }

}
