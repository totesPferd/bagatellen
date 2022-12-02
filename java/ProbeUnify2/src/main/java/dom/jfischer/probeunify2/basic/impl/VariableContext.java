/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.basic.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.IExtension;
import dom.jfischer.probeunify2.basic.ILeafCollector;
import dom.jfischer.probeunify2.basic.ITracker;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.basic.IVariable;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Collection;
import java.util.Collections;
import java.util.Optional;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import dom.jfischer.probeunify2.basic.IVariableContext;
import java.util.stream.Collectors;

/**
 *
 * @author jfischer
 * @param <Extension>
 * @param <NonVariableExtension>
 */
public class VariableContext<Extension extends IExtension, NonVariableExtension extends IExtension> implements
        IVariableContext<Extension, NonVariableExtension> {

    private final IVariableContext<Extension, NonVariableExtension> parent;

    private final Map<IVariable<NonVariableExtension>, String> backRef
            = new ConcurrentHashMap<>();
    private final Map<Extension, Map<String, List<IVariable<NonVariableExtension>>>> ref
            = new ConcurrentHashMap<>();
    private final Map<IVariable<NonVariableExtension>, Extension> extensionMap
            = new ConcurrentHashMap<>();
    private final List<IVariable<NonVariableExtension>> unsortedVariables
            = Collections.synchronizedList(new ArrayList<>());

    public VariableContext(IVariableContext<Extension, NonVariableExtension> parent) {
        this.parent = parent;
    }

    public VariableContext() {
        this.parent = null;
    }

    @Override
    public Optional<IVariableContext<Extension, NonVariableExtension>> getParent() {
        return Optional.ofNullable(this.parent);
    }

    @Override
    public void addUnsortedVariable(IVariable<NonVariableExtension> variable) {
        if (!this.extensionMap.containsKey(variable) && !this.unsortedVariables.contains(variable)) {
            this.unsortedVariables.add(variable);
        }
    }

    @Override
    public IVariable<NonVariableExtension> createVariable(Extension extension, String name) {

        IVariable<NonVariableExtension> retval = new Variable<>();
        retval = new Variable<>();
        this.backRef.put(retval, name);
        this.extensionMap.put(retval, extension);

        addRef(retval, extension, name, this);

        return retval;
    }

    @Override
    public String getName(IVariable<NonVariableExtension> variable) {
        String retval = null;
        List<IVariable<NonVariableExtension>> varList = null;
        int parentIndex = 0;
        if (parent != null && !this.backRef.containsKey(variable)) {
            retval = this.parent.getName(variable);
        } else {
            if (this.backRef.containsKey(variable)) {
                Extension extension = this.extensionMap.get(variable);
                Map<String, List<IVariable<NonVariableExtension>>> extensionRef
                        = this.ref.get(extension);
                retval = this.backRef.get(variable);
                varList = extensionRef.get(retval)
                        .parallelStream()
                        .filter(v -> v.isLeaf() || v == variable)
                        .collect(Collectors.toList());
                if (this.parent != null) {
                    parentIndex += this.parent.getCard(retval, extension);
                }
            } else {
                retval = "__";
                varList = this.unsortedVariables
                        .parallelStream()
                        .filter(v -> v.isLeaf() || v == variable)
                        .collect(Collectors.toList());
                if (this.parent != null) {
                    parentIndex += this.parent.getCardUnsorted();
                }
            }
            int varListLgth = varList.size();

            if (parentIndex + varListLgth > 1) {
                for (int i = 0; i < varListLgth; i++) {
                    IVariable<NonVariableExtension> cmpVar
                            = varList.get(i).variable().get();
                    if (cmpVar == variable) {
                        retval += "_" + (parentIndex + i);
                        break;
                    }
                }
            }
        }

        return retval;
    }

    @Override
    public Extension getSort(IVariable<NonVariableExtension> variable) {
        Extension retval = null;

        if (this.extensionMap.containsKey(variable)) {
            retval = this.extensionMap.get(variable);
        } else if (this.parent != null) {
            retval = this.parent.getSort(variable);
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

        this.extensionMap.keySet().retainAll(vars);
        this.backRef.keySet().retainAll(vars);

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
        IVariableContext<Extension, NonVariableExtension> retval = new VariableContext<>(this.parent);
        Map<IVariable<NonVariableExtension>, Extension> otherExtensionMap
                = retval.getExtensionMap();
        {
            Map<IVariable<NonVariableExtension>, String> otherBackRef
                    = retval.getBackRef();

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
            List<IVariable<NonVariableExtension>> otherUnsortedVariables
                    = retval.getUnsortedVariables();
            for (IVariable<NonVariableExtension> thisUnsortedVariable : this.unsortedVariables) {
                Optional<IVariable<NonVariableExtension>> optOtherUnsortedVariable
                        = thisUnsortedVariable.copy(tracker).variable();
                if (optOtherUnsortedVariable.isPresent()) {
                    IVariable<NonVariableExtension> otherUnsortedVariable
                            = optOtherUnsortedVariable.get();
                    otherUnsortedVariables.add(thisUnsortedVariable);
                    otherExtensionMap.put(otherUnsortedVariable, this.extensionMap.get(thisUnsortedVariable));
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
    public void collectLeafs(ILeafCollector<NonVariableExtension> leafCollector
    ) {
        Set<IVariable<NonVariableExtension>> leafs = leafCollector.getLeafs();
        this.backRef.keySet().forEach(var -> leafs.add(var));
    }

    @Override
    public boolean isFree(IVariable<NonVariableExtension> variable
    ) {
        return !this.extensionMap.containsKey(variable)
                && !this.unsortedVariables.contains(variable);
    }

    @Override
    public IVariableContext<Extension, NonVariableExtension> getVariableContext(IVariable<NonVariableExtension> variable
    ) {
        IVariableContext<Extension, NonVariableExtension> retval = this;

        if (this.isFree(variable)) {
            retval
                    = this.parent == null
                            ? null
                            : this.parent.getVariableContext(variable);
        }

        return retval;
    }

    @Override
    public boolean unite() {
        boolean retval = this.parent != null;

        if (retval) {
            this.extensionMap.keySet()
                    .parallelStream()
                    .forEach(var -> move(var, this, this.parent));
        }

        return retval;
    }

    @Override
    public boolean separate(Set<IVariable<NonVariableExtension>> variableSet
    ) {
        boolean retval = this.parent != null;

        if (retval) {
            variableSet
                    .parallelStream()
                    .forEach(var -> move(var, this.getVariableContext(var), this));
        }

        return retval;
    }

    @Override
    public int getCard(String name, Extension sort) {
        int retval = 0;

        if (parent != null) {
            retval += parent.getCard(name, sort);
        }

        if (this.ref.containsKey(sort)) {
            Map<String, List<IVariable<NonVariableExtension>>> excerpt
                    = this.ref.get(sort);
            if (excerpt.containsKey(name)) {
                retval += excerpt.get(name)
                        .parallelStream()
                        .filter(v -> v.isLeaf())
                        .count();
            }
        }

        return retval;
    }

    private static <Extension extends IExtension, NonVariableExtension extends IExtension> void addRef(
            IVariable<NonVariableExtension> variable,
            Extension extension,
            String variableBaseName,
            IVariableContext<Extension, NonVariableExtension> variableContext
    ) {
        Map<String, List<IVariable<NonVariableExtension>>> extensionRef = null;
        if (variableContext.getRef().containsKey(extension)) {
            extensionRef = variableContext.getRef().get(extension);
        } else {
            extensionRef = new ConcurrentHashMap<>();
            variableContext.getRef().put(extension, extensionRef);
        }

        List<IVariable<NonVariableExtension>> varList = null;
        if (extensionRef.containsKey(variableBaseName)) {
            varList = extensionRef.get(variableBaseName);
        } else {
            varList = Collections.synchronizedList(new ArrayList<>());
            extensionRef.put(variableBaseName, varList);
        }
        varList.add(variable);

    }

    private static <Extension extends IExtension, NonVariableExtension extends IExtension> void move(
            IVariable<NonVariableExtension> variable,
            IVariableContext<Extension, NonVariableExtension> from,
            IVariableContext<Extension, NonVariableExtension> to) {

        Map<IVariable<NonVariableExtension>, Extension> fromExtensionMap
                = from.getExtensionMap();
        Extension extension
                = fromExtensionMap.get(variable);

        fromExtensionMap.remove(variable);
        to.getExtensionMap().put(variable, extension);

        Map<IVariable<NonVariableExtension>, String> fromBackRef
                = from.getBackRef();
        if (fromBackRef.containsKey(variable)) {
            String variableNameBase
                    = fromBackRef.get(variable);
            fromBackRef.remove(variable);
            to.getBackRef().put(variable, variableNameBase);
            from.getRef().get(extension).get(variableNameBase).remove(variable);
            addRef(variable, extension, variableNameBase, to);
        } else {
            from.getUnsortedVariables().remove(variable);
            to.addUnsortedVariable(variable);
        }

    }

    @Override
    public int getCardUnsorted() {
        int retval = 0;

        if (this.parent != null) {
            retval += this.parent.getCardUnsorted();
        }

        retval += this.unsortedVariables
                .parallelStream()
                .filter(v -> v.isLeaf())
                .count();

        return retval;
    }

}
