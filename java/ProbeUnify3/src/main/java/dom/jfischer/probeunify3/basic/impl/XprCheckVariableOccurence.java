/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify3.basic.impl;

import dom.jfischer.probeunify3.basic.ICheckVariableOccurence;
import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.IVariable;
import dom.jfischer.probeunify3.basic.IXpr;

/**
 *
 * @author jfischer
 * @param <NonVariableXt>
 */
public class XprCheckVariableOccurence<NonVariableXt extends INonVariableXt> implements
        ICheckVariableOccurence<NonVariableXt, IXpr<NonVariableXt>> {

    @Override
    public boolean containsVariable(IXpr<NonVariableXt> object, IVariable<NonVariableXt> variable) {
        return object.containsVariable(variable);
    }
    
}
