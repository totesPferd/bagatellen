/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify3.basic.impl;

import dom.jfischer.probeunify3.basic.ITNonVariableXt;
import dom.jfischer.probeunify3.basic.IUnification;
import dom.jfischer.probeunify3.basic.IXpr;
import java.util.List;

/**
 *
 * @author jfischer
 */
public class TNonVariableXtUnification implements IUnification<ITNonVariableXt> {

    private final IUnification<List<IXpr<ITNonVariableXt>>> multiXprUnification;

    public TNonVariableXtUnification() {
        IUnification<IXpr<ITNonVariableXt>> xprUnification
                = new XprUnification<>();
        this.multiXprUnification
                = new MultiUnification<>(xprUnification);
    }

    @Override
    public boolean unify(ITNonVariableXt arg1, ITNonVariableXt arg2) {
        return arg1.getSymbol().eq(arg2.getSymbol())
                && this.multiXprUnification.unify(arg1.getArguments(), arg2.getArguments());
    }

}
