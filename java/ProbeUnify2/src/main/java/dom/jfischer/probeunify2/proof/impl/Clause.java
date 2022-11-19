/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.proof.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.proof.IClause;
import java.util.List;

/**
 *
 * @author jfischer
 */
public class Clause implements IClause {

    private final IBaseExpression<ILiteralNonVariableExtension> conclusion;
    private final List<IBaseExpression<ILiteralNonVariableExtension>> premises;

    public Clause(IBaseExpression<ILiteralNonVariableExtension> conclusion, List<IBaseExpression<ILiteralNonVariableExtension>> premises) {
        this.conclusion = conclusion;
        this.premises = premises;
    }

    @Override
    public IBaseExpression<ILiteralNonVariableExtension> getConclusion() {
        return this.conclusion;
    }

    @Override
    public List<IBaseExpression<ILiteralNonVariableExtension>> getPremises() {
        return this.premises;
    }

    @Override
    public void commit() {
        this.conclusion.commit();
        this.premises
                .stream()
                .forEach(IBaseExpression<ILiteralNonVariableExtension>::commit);
    }

    @Override
    public void reset() {
        this.conclusion.reset();
        this.premises
                .stream()
                .forEach(IBaseExpression<ILiteralNonVariableExtension>::reset);
    }

}
