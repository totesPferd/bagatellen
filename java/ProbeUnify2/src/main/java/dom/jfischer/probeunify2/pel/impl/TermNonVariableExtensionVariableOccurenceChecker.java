/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.ICheckVariableOccurence;
import dom.jfischer.probeunify2.basic.IVariable;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;

/**
 *
 * @author jfischer
 */
public class TermNonVariableExtensionVariableOccurenceChecker implements
        ICheckVariableOccurence<ITermNonVariableExtension> {

    @Override
    public boolean containsVariable(ITermNonVariableExtension object, IVariable<ITermNonVariableExtension> variable) {
        return
                object.getArguments()
                .parallelStream()
                .anyMatch(term -> term.containsVariable(variable));
    }
    
}
