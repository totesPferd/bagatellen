/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify3.basic.impl;

import dom.jfischer.probeunify3.basic.ICheckVariableOccurence;
import dom.jfischer.probeunify3.basic.ITNonVariableXt;
import dom.jfischer.probeunify3.basic.IVariable;

/**
 *
 * @author jfischer
 */
public class TNonVariableXtCheckVariableOccurence implements
        ICheckVariableOccurence<ITNonVariableXt, ITNonVariableXt> {

    @Override
    public boolean containsVariable(ITNonVariableXt object, IVariable<ITNonVariableXt> variable) {
        return object.getArguments()
                .parallelStream()
                .anyMatch(arg -> arg.containsVariable(variable));
    }

}
