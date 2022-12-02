/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.IPELVariableContext;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import dom.jfischer.probeunify2.basic.IVariableContext;
import dom.jfischer.probeunify2.basic.impl.VariableContext;

/**
 *
 * @author jfischer
 */
public class PELVariableContext implements IPELVariableContext {

    private final IVariableContext<ITrivialExtension, ILiteralNonVariableExtension> literalVariableContext;
    private final IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension> termVariableContext;

    public PELVariableContext() {
        this.literalVariableContext
                = new VariableContext<>();
        this.termVariableContext
                = new VariableContext<>();
    }

    public PELVariableContext(IVariableContext<ITrivialExtension, ILiteralNonVariableExtension> literalVariableContext, IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension> termVariableContext) {
        this.literalVariableContext = literalVariableContext;
        this.termVariableContext = termVariableContext;
    }

    public PELVariableContext(IPELVariableContext parent) {
        this.literalVariableContext
                = new VariableContext<>(parent.getLiteralVariableContext());
        this.termVariableContext
                = new VariableContext<>(parent.getTermVariableContext());
    }

    @Override
    public IVariableContext<ITrivialExtension, ILiteralNonVariableExtension> getLiteralVariableContext() {
        return this.literalVariableContext;
    }

    @Override
    public IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension> getTermVariableContext() {
        return this.termVariableContext;
    }

    @Override
    public void commit() {
        this.literalVariableContext.commit();
        this.termVariableContext.commit();
    }

    @Override
    public void reset() {
        this.literalVariableContext.reset();
        this.termVariableContext.reset();
    }

}
