/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2.pprint;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.IExtension;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.basic.IVariable;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 *
 * @author jfischer
 */
public interface ITermVariableContext extends
        IExtension {

    IVariable<ITermNonVariableExtension> createVariable(IBaseExpression<ITrivialExtension> sort, String name);

    void addUnsortedVariable(IVariable<ITermNonVariableExtension> variable);
    
    String getName(IVariable<ITermNonVariableExtension> variable);

    void unify(ITermVariableContext other);

    Map<IVariable<ITermNonVariableExtension>, String> getBackRef();

    Map<IBaseExpression<ITrivialExtension>, Map<String, List<IVariable<ITermNonVariableExtension>>>> getRef();

    Map<IVariable<ITermNonVariableExtension>, IBaseExpression<ITrivialExtension>> getSortMap();
    
    List<IVariable<ITermNonVariableExtension>> getUnsortedVariables();

    void retainAll(Set<IVariable<ITermNonVariableExtension>> vars);

}
