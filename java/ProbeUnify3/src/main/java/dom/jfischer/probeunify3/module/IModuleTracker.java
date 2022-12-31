/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify3.module;

import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.ITNonVariableXt;
import dom.jfischer.probeunify3.basic.ITracker;
import dom.jfischer.probeunify3.basic.IXpr;

/**
 *
 * @author jfischer
 * @param <Xt>
 */
public interface IModuleTracker<Xt extends IModuleXt> {

    ITracker<IXpr<INonVariableXt>> getCTracker();

    ITracker<IXpr<ITNonVariableXt>> getTTracker();
    
    ITracker<IModule<Xt>> getMTracker();
}
