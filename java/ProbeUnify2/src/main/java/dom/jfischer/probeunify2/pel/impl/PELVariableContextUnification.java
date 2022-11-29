/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.basic.IUnification;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.IPELVariableContext;
import dom.jfischer.probeunify2.pel.ITermExtension;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import dom.jfischer.probeunify2.basic.IVariableContext;
import dom.jfischer.probeunify2.basic.impl.VariableContextUnification;

/**
 *
 * @author jfischer
 */
public class PELVariableContextUnification implements IUnification<IPELVariableContext> {

    private final IUnification<IVariableContext<ITrivialExtension, ILiteralNonVariableExtension>> literalVariableContextUnification
            = new VariableContextUnification<>();
    private final IUnification<IVariableContext<ITermExtension, ITermNonVariableExtension>> termVariableContextUnification
            = new VariableContextUnification<>();

    @Override
    public boolean unify(IPELVariableContext arg1, IPELVariableContext arg2) {
        return this.literalVariableContextUnification.unify(arg1.getLiteralVariableContext(), arg2.getLiteralVariableContext())
                && this.termVariableContextUnification.unify(arg1.getTermVariableContext(), arg2.getTermVariableContext());
    }

}
