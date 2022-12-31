/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.names;

import com.google.common.collect.ListMultimap;
import dom.jfischer.probeunify3.basic.ITNonVariableXt;
import dom.jfischer.probeunify3.basic.IVariable;
import java.io.Serializable;
import java.util.List;
import java.util.Set;

/**
 *
 * @author jfischer
 */
public interface IVariableNameInfo extends Serializable {
    
    void addVariable(String name, IVariable<ITNonVariableXt> variable);
    
    ListMultimap<String, IVariable<ITNonVariableXt>> getVariableNames();
    
    List<IVariable<ITNonVariableXt>> getUnsortedVariables();
    
    String getName(IVariable<ITNonVariableXt> variable);
    
    void retainAll(Set<IVariable<ITNonVariableXt>> variables);
    
}
