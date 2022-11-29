/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.basic.impl;

import dom.jfischer.probeunify2.basic.IExtension;
import dom.jfischer.probeunify2.basic.ILeafCollector;
import dom.jfischer.probeunify2.basic.ITracker;
import dom.jfischer.probeunify2.basic.IVariable;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Collection;
import java.util.Collections;
import java.util.Optional;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;
import dom.jfischer.probeunify2.basic.IVariableContext;

/**
 *
 * @author jfischer
 * @param <Extension>
 * @param <NonVariableExtension>
 */
public class VariableContext<Extension extends IExtension, NonVariableExtension extends IExtension> implements
        IVariableContext<Extension, NonVariableExtension> {

    private final Map<IVariable<NonVariableExtension>, String> backRef
            = new ConcurrentHashMap<>();
    private final Map<Extension, Map<String, List<IVariable<NonVariableExtension>>>> ref
            = new ConcurrentHashMap<>();
    private final Map<IVariable<NonVariableExtension>, Extension> extensionMap
            = new ConcurrentHashMap<>();
    private final List<IVariable<NonVariableExtension>> unsortedVariables
            = Collections.synchronizedList(new ArrayList<>());

    @Override
    public void addUnsortedVariable(IVariable<NonVariableExtension> variable) {
        if (!this.extensionMap.containsKey(variable) && !this.unsortedVariables.contains(variable)) {
            this.unsortedVariables.add(variable);
        }
    }

    @Override
    public IVariable<NonVariableExtension> createVariable(Extension extension, String name) {

        Map<String, List<IVariable<NonVariableExtension>>> extensionRef = null;
        if (this.ref.containsKey(extension)) {
            extensionRef = this.ref.get(extension);
        } else {
            extensionRef = new ConcurrentHashMap<>();
            this.ref.put(extension, extensionRef);
        }

        List<IVariable<NonVariableExtension>> varList = null;
        if (extensionRef.containsKey(name)) {
            varList = extensionRef.get(name);
        } else {
            varList = Collections.synchronizedList(new ArrayList<>());
            extensionRef.put(name, varList);
        }

        IVariable<NonVariableExtension> retval = new Variable<>();
        retval = new Variable<>();
        this.backRef.put(retval, name);
        this.extensionMap.put(retval, extension);
        varList.add(retval);

        return retval;
    }

    @Override
    public String getName(IVariable<NonVariableExtension> variable) {
        String retval = null;
        List<IVariable<NonVariableExtension>> varList = null;
        if (this.extensionMap.containsKey(variable)) {
            Extension extension = this.extensionMap.get(variable);
            Map<String, List<IVariable<NonVariableExtension>>> extensionRef
                    = this.ref.get(extension);
            retval = this.backRef.get(variable);
            varList = extensionRef.get(retval);
        } else {
            retval = "__";
            varList = this.unsortedVariables;
        }
        int varListLgth = varList.size();

        if (varListLgth > 1) {
            for (int i = 0; i < varListLgth; i++) {
                IVariable<NonVariableExtension> cmpVar
                        = varList.get(i).variable().get();
                if (cmpVar == variable) {
                    retval += "_" + i;
                    break;
                }
            }
        }

        return retval;
    }

    @Override
    public Map<IVariable<NonVariableExtension>, String> getBackRef() {
        return this.backRef;
    }

    @Override
    public Map<Extension, Map<String, List<IVariable<NonVariableExtension>>>> getRef() {
        return this.ref;
    }

    @Override
    public void commit() {
        this.backRef.keySet().forEach(var -> var.commit());
    }

    @Override
    public void reset() {
        this.backRef.keySet().forEach(var -> var.reset());
    }

    @Override
    public Map<IVariable<NonVariableExtension>, Extension> getExtensionMap() {
        return this.extensionMap;
    }

    @Override
    public List<IVariable<NonVariableExtension>> getUnsortedVariables() {
        return this.unsortedVariables;
    }

    @Override
    public void retainAll(Set<IVariable<NonVariableExtension>> vars) {
        {
            Set<IVariable<NonVariableExtension>> invalidVars
                    = Collections.synchronizedSet(this.extensionMap.keySet()
                            .parallelStream()
                            .filter(v -> !vars.contains(v))
                            .collect(Collectors.toSet()));
            for (IVariable<NonVariableExtension> var : invalidVars) {
                this.extensionMap.remove(var);
            }
        }
        {
            Set<IVariable<NonVariableExtension>> invalidVars
                    = Collections.synchronizedSet(this.backRef.keySet()
                            .parallelStream()
                            .filter(v -> !vars.contains(v))
                            .collect(Collectors.toSet()));
            for (IVariable<NonVariableExtension> var : invalidVars) {
                this.backRef.remove(var);
            }
        }
        {
            Collection<String> names = this.backRef.values();
            for (Map<String, List<IVariable<NonVariableExtension>>> s : this.ref.values()) {
                s.keySet().retainAll(names);
            }
        }
        this.unsortedVariables.retainAll(vars);
        this.ref.values()
                .parallelStream()
                .map(al -> al.values())
                .forEach(al -> al.parallelStream().forEach(bl -> bl.retainAll(vars)));
    }

    @Override
    public IVariableContext<Extension, NonVariableExtension> copy(ITracker<NonVariableExtension> tracker) {
        IVariableContext<Extension, NonVariableExtension> retval = new VariableContext<>();
        {
            Map<IVariable<NonVariableExtension>, String> otherBackRef = retval.getBackRef();
            Map<IVariable<NonVariableExtension>, Extension> otherExtensionMap
                    = retval.getExtensionMap();
            for (Map.Entry<IVariable<NonVariableExtension>, String> thisBackRefEntry : this.backRef.entrySet()) {
                IVariable<NonVariableExtension> thisVariable = thisBackRefEntry.getKey();
                Optional<IVariable<NonVariableExtension>> optOtherVariable
                        = thisVariable.copy(tracker).variable();
                if (optOtherVariable.isPresent()) {
                    IVariable<NonVariableExtension> otherVariable = optOtherVariable.get();
                    otherBackRef.put(otherVariable, thisBackRefEntry.getValue());
                    otherExtensionMap.put(otherVariable, this.extensionMap.get(thisVariable));
                }
            }
        }
        {
            Map<Extension, Map<String, List<IVariable<NonVariableExtension>>>> otherRef
                    = retval.getRef();
            for (Map.Entry<Extension, Map<String, List<IVariable<NonVariableExtension>>>> thisEntry : this.ref.entrySet()) {
                Map<String, List<IVariable<NonVariableExtension>>> thisExtensionRef
                        = thisEntry.getValue();
                Map<String, List<IVariable<NonVariableExtension>>> otherExtensionRef
                        = new ConcurrentHashMap<>();
                otherRef.put(thisEntry.getKey(), otherExtensionRef);
                for (Map.Entry<String, List<IVariable<NonVariableExtension>>> thisSEntry : thisExtensionRef.entrySet()) {
                    String sKey = thisSEntry.getKey();
                    for (IVariable<NonVariableExtension> variable : thisExtensionRef.get(sKey)) {
                        Optional<IVariable<NonVariableExtension>> optVariableCopy
                                = variable.copy(tracker).variable();
                        if (optVariableCopy.isPresent()) {
                            IVariable<NonVariableExtension> variableCopy
                                    = optVariableCopy.get();
                            List<IVariable<NonVariableExtension>> otherS
                                    = null;
                            if (otherExtensionRef.containsKey(sKey)) {
                                otherS = otherExtensionRef.get(sKey);
                            } else {
                                otherS = Collections.synchronizedList(new ArrayList<>());
                                otherExtensionRef.put(sKey, otherS);
                            }
                            otherS.add(variableCopy);
                        }
                    }
                }
            }
        }
        return retval;
    }

    @Override
    public void collectLeafs(ILeafCollector<NonVariableExtension> leafCollector) {
        Set<IVariable<NonVariableExtension>> leafs = leafCollector.getLeafs();
        this.backRef.keySet().forEach(var -> leafs.add(var));
    }

}
