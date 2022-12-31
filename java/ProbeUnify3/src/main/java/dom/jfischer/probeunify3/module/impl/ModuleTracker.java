/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify3.module.impl;

import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.ITNonVariableXt;
import dom.jfischer.probeunify3.basic.ITracker;
import dom.jfischer.probeunify3.basic.IXpr;
import dom.jfischer.probeunify3.basic.impl.Tracker;
import dom.jfischer.probeunify3.module.IModule;
import dom.jfischer.probeunify3.module.IModuleTracker;
import dom.jfischer.probeunify3.module.IModuleXt;

/**
 *
 * @author jfischer
 */
public class ModuleTracker<Xt extends IModuleXt> implements IModuleTracker<Xt> {

    private final ITracker<IXpr<INonVariableXt>> cTracker
            =  new Tracker<>();
    private final ITracker<IXpr<ITNonVariableXt>> tTracker
            =  new Tracker<>();
    private final ITracker<IModule<Xt>> mTracker
            =  new Tracker<>();
    
    @Override
    public ITracker<IXpr<INonVariableXt>> getCTracker() {
        return this.cTracker;
    }

    @Override
    public ITracker<IXpr<ITNonVariableXt>> getTTracker() {
        return this.tTracker;
    }

    @Override
    public ITracker<IModule<Xt>> getMTracker() {
        return this.mTracker;
    }
    
}
