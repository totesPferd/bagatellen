/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2.basic;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

/**
 *
 * @author jfischer
 * @param <Extension>
 * @param <NonVariableExtension>
 */
public interface IVariableContext<Extension extends IExtension, NonVariableExtension extends IExtension> extends
        IExtension {

    Optional<IVariableContext<Extension, NonVariableExtension>> getParent();

    IVariable<NonVariableExtension> createVariable(Extension extension, String name);

    void addUnsortedVariable(IVariable<NonVariableExtension> variable);

    String getName(IVariable<NonVariableExtension> variable);
    
    Extension getSort(IVariable<NonVariableExtension> variable);

    Map<IVariable<NonVariableExtension>, String> getBackRef();

    Map<Extension, Map<String, List<IVariable<NonVariableExtension>>>> getRef();

    Map<IVariable<NonVariableExtension>, Extension> getExtensionMap();

    List<IVariable<NonVariableExtension>> getUnsortedVariables();

    void retainAll(Set<IVariable<NonVariableExtension>> vars);

    IVariableContext<Extension, NonVariableExtension> copy(ITracker<NonVariableExtension> tracker);

    void collectLeafs(ILeafCollector<NonVariableExtension> leafCollector);

    boolean isFree(IVariable<NonVariableExtension> variable);

    IVariableContext<Extension, NonVariableExtension> getVariableContext(IVariable<NonVariableExtension> variable);

    boolean unite();

    boolean separate(Set<IVariable<NonVariableExtension>> variableSet);

    int getCard(String name, Extension sort);

    int getCardUnsorted();
    
}
