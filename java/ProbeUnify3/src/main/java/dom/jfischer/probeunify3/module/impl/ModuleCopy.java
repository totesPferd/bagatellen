/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify3.module.impl;

import dom.jfischer.probeunify3.basic.IClause;
import dom.jfischer.probeunify3.basic.ICopy;
import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.ITNonVariableXt;
import dom.jfischer.probeunify3.basic.ITracker;
import dom.jfischer.probeunify3.basic.IXpr;
import dom.jfischer.probeunify3.basic.impl.CXprCopy;
import dom.jfischer.probeunify3.basic.impl.ClauseSignatureCopy;
import dom.jfischer.probeunify3.module.IModule;
import dom.jfischer.probeunify3.module.IModuleTracker;
import dom.jfischer.probeunify3.module.IModuleXt;
import dom.jfischer.probeunify3.module.IObject;
import java.util.Map;
import java.util.Optional;

/**
 *
 * @author jfischer
 * @param <Xt>
 */
public class ModuleCopy<Xt extends IModuleXt> implements
        ICopy<IModule<Xt>, IModuleTracker<Xt>> {

    private final ICopy<IClause, ITracker<IXpr<INonVariableXt>>> axiomsCopier
            = new ClauseSignatureCopy();
    private final ICopy<IXpr<INonVariableXt>, ITracker<IXpr<INonVariableXt>>> cCopier
            = new CXprCopy();
    private final ICopy<Xt, ITracker<IXpr<INonVariableXt>>> xtCopier;

    public ModuleCopy(ICopy<Xt, ITracker<IXpr<INonVariableXt>>> xtCopier) {
        this.xtCopier = xtCopier;
    }

    @Override
    public IModule<Xt> copy(IModuleTracker<Xt> tracker, IModule<Xt> object) {
        Optional<IModule<Xt>> optObjectCopy = tracker.getMTracker().get(object);
        IModule<Xt> retval = null;

        if (optObjectCopy.isPresent()) {
            retval = optObjectCopy.get();
        } else {
            ITracker<IXpr<INonVariableXt>> cTracker = tracker.getCTracker();
            ITracker<IXpr<ITNonVariableXt>> tTracker = tracker.getTTracker();
            retval = new Module<>(this.xtCopier.copy(cTracker, object.getXt()));
            {
                Map<IObject, IClause> outAxioms = retval.getAxioms();
                object.getAxioms().entrySet()
                        .stream()
                        .forEach(clauseEntry -> outAxioms.put(
                        clauseEntry.getKey(),
                        this.axiomsCopier.copy(cTracker, clauseEntry.getValue())));
            }
            {
                Map<IObject, IXpr<INonVariableXt>> outCs = retval.getCs();
                object.getCs().entrySet()
                        .stream()
                        .forEach(cEntry -> outCs.put(
                        cEntry.getKey(),
                        this.cCopier.copy(cTracker, cEntry.getValue())));
            }
            {
                Map<IObject, IModule<Xt>> outImports = retval.getImports();
                object.getImports().entrySet()
                        .stream()
                        .forEach(mEntry -> outImports.put(
                        mEntry.getKey(),
                        this.copy(tracker, mEntry.getValue())));
            }
            tracker.getMTracker().put(object, retval);
        }

        return retval;
    }

}
