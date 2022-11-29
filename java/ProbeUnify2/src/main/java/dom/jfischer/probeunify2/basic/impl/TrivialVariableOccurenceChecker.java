/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.basic.impl;

import dom.jfischer.probeunify2.basic.ICheckVariableOccurence;
import dom.jfischer.probeunify2.basic.IExtension;
import dom.jfischer.probeunify2.basic.IVariable;

/**
 *
 * @author jfischer
 * @param <NonVariableExtension>
 */
public class TrivialVariableOccurenceChecker<NonVariableExtension extends IExtension> implements
        ICheckVariableOccurence<NonVariableExtension> {

    @Override
    public boolean containsVariable(NonVariableExtension object, IVariable<NonVariableExtension> variable) {
        return false;
    }

}
