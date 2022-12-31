/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify3.basic.impl;

import dom.jfischer.probeunify3.basic.ILeafCollecting;
import dom.jfischer.probeunify3.basic.ILeafCollector;
import dom.jfischer.probeunify3.basic.ITNonVariableXt;

/**
 *
 * @author jfischer
 */
public class TNonVariableXtLeafCollecting implements
        ILeafCollecting<ITNonVariableXt, ITNonVariableXt> {

    @Override
    public void collectLeafs(ILeafCollector<ITNonVariableXt> leafCollector, ITNonVariableXt object) {
        object.getArguments()
                .parallelStream()
                .forEach(arg -> arg.collectLeafs(leafCollector));
    }

}
