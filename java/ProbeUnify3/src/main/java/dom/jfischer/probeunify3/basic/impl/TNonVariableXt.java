/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify3.basic.impl;

import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.ITNonVariableXt;
import dom.jfischer.probeunify3.basic.IXpr;
import java.util.List;

/**
 *
 * @author jfischer
 */
public class TNonVariableXt implements ITNonVariableXt {

    private final IXpr<INonVariableXt> symbol;
    private final List<IXpr<ITNonVariableXt>> arguments;

    public TNonVariableXt(IXpr<INonVariableXt> symbol, List<IXpr<ITNonVariableXt>> arguments) {
        this.symbol = symbol;
        this.arguments = arguments;
    }
    
    @Override
    public IXpr<INonVariableXt> getSymbol() {
        return this.symbol;
    }

    @Override
    public List<IXpr<ITNonVariableXt>> getArguments() {
        return this.arguments;
    }

    @Override
    public void commit() {
        this.symbol.commit();
        this.arguments
                .parallelStream()
                .forEach(arg -> arg.commit());
    }

    @Override
    public void reset() {
        this.symbol.reset();
        this.arguments
                .parallelStream()
                .forEach(arg -> arg.reset());
    }
    
}
