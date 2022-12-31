/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify3.module.impl;

import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.IUnification;
import dom.jfischer.probeunify3.basic.IXpr;
import dom.jfischer.probeunify3.basic.impl.DictUnification;
import dom.jfischer.probeunify3.basic.impl.XprUnification;
import dom.jfischer.probeunify3.module.IModule;
import dom.jfischer.probeunify3.module.IModuleXt;
import dom.jfischer.probeunify3.module.IObject;
import java.util.Map;

/**
 *
 * @author jfischer
 * @param <Xt>
 */
public class ModuleUnification<Xt extends IModuleXt> implements IUnification<IModule<Xt>> {

    private final IUnification<Xt> xtUnification;

    private final IUnification<Map<IObject, IModule<Xt>>> importsUnification
            = new DictUnification<>(this);
    private final IUnification<Map<IObject, IXpr<INonVariableXt>>> cUnification;

    public ModuleUnification(IUnification<Xt> xtUnification) {
        this.xtUnification = xtUnification;

        {
            IUnification<IXpr<INonVariableXt>> baseUnification
                    = new XprUnification<>();
            this.cUnification
                    = new DictUnification<>(baseUnification);
        }
    }

    @Override
    public boolean unify(IModule<Xt> arg1, IModule<Xt> arg2) {
        boolean retval
                = this.xtUnification.unify(arg1.getXt(), arg2.getXt())
                && this.importsUnification.unify(arg1.getImports(), arg2.getImports())
                && this.cUnification.unify(arg1.getCs(), arg2.getCs());

        if (!retval) {
            arg1.reset();
            arg2.reset();
        }

        return retval;
    }

}
