/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify3.basic;

import java.io.Serializable;
import java.util.Set;

/**
 *
 * @author jfischer
 * @param <NonVariableXt>
 * @param <Type>
 */
public interface ICheckVariableOccurence<NonVariableXt extends INonVariableXt, Type> extends
        Serializable {

    boolean containsVariable(Type object, IVariable<NonVariableXt> variable);

    default boolean isConstant(Type object, IVariableContext<NonVariableXt> variableContext) {
        Set<IVariable<NonVariableXt>> variables
                = variableContext.getVariables();
        return variables
                .parallelStream()
                .allMatch(var -> !this.containsVariable(object, var));
    }
    
}
