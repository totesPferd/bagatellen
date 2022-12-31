/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify3.basic;

import java.io.Serializable;
import java.util.Optional;
import java.util.Set;

/**
 *
 * @author jfischer
 * @param <NonVariableXt>
 */
public interface IVariableContext<NonVariableXt extends INonVariableXt> extends Serializable {
    
    Optional<IVariableContext<NonVariableXt>> getParent();
    
    Set<IVariable<NonVariableXt>> getVariables();
    
    IVariableContext<NonVariableXt> copy(ITracker<IXpr<NonVariableXt>> tracker);
    
    IVariable<NonVariableXt> createVariable();
    
}
