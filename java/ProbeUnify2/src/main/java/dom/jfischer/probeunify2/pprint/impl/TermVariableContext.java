/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pprint.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.basic.IVariable;
import dom.jfischer.probeunify2.basic.impl.Variable;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import dom.jfischer.probeunify2.pprint.ITermVariableContext;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Collection;
import java.util.Collections;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

/**
 *
 * @author jfischer
 */
public class TermVariableContext implements ITermVariableContext {

    private final Map<IVariable<ITermNonVariableExtension>, String> backRef
            = new ConcurrentHashMap<>();
    private final Map<IBaseExpression<ITrivialExtension>, Map<String, List<IVariable<ITermNonVariableExtension>>>> ref
            = new ConcurrentHashMap<>();
    private final Map<IVariable<ITermNonVariableExtension>, IBaseExpression<ITrivialExtension>> sortMap
            = new ConcurrentHashMap<>();
    private final List<IVariable<ITermNonVariableExtension>> unsortedVariables
            = Collections.synchronizedList(new ArrayList<>());

    @Override
    public void addUnsortedVariable(IVariable<ITermNonVariableExtension> variable) {
        if (!this.sortMap.containsKey(variable) && !this.unsortedVariables.contains(variable)) {
            this.unsortedVariables.add(variable);
        }
    }

    @Override
    public IVariable<ITermNonVariableExtension> createVariable(IBaseExpression<ITrivialExtension> sort, String name) {

        Map<String, List<IVariable<ITermNonVariableExtension>>> sortRef = null;
        if (this.ref.containsKey(sort)) {
            sortRef = this.ref.get(sort);
        } else {
            sortRef = new ConcurrentHashMap<>();
            this.ref.put(sort, sortRef);
        }

        List<IVariable<ITermNonVariableExtension>> varList = null;
        if (sortRef.containsKey(name)) {
            varList = sortRef.get(name);
        } else {
            varList = Collections.synchronizedList(new ArrayList<>());
            sortRef.put(name, varList);
        }

        IVariable<ITermNonVariableExtension> retval = new Variable<>();
        retval = new Variable<>();
        this.backRef.put(retval, name);
        this.sortMap.put(retval, sort);
        varList.add(retval);

        return retval;
    }

    @Override
    public String getName(IVariable<ITermNonVariableExtension> variable) {
        String retval = null;
        List<IVariable<ITermNonVariableExtension>> varList = null;
        if (this.sortMap.containsKey(variable)) {
            IBaseExpression<ITrivialExtension> sort = this.sortMap.get(variable);
            Map<String, List<IVariable<ITermNonVariableExtension>>> sortRef = this.ref.get(sort);
            retval = this.backRef.get(variable);
            varList = sortRef.get(retval);
        } else {
            retval = "__";
            varList = this.unsortedVariables;
        }
        int varListLgth = varList.size();

        if (varListLgth > 1) {
            for (int i = 0; i < varListLgth; i++) {
                IVariable<ITermNonVariableExtension> cmpVar
                        = varList.get(i).variable().get();
                if (cmpVar == variable) {
                    retval += "_" + i;
                    break;
                }
            }
        }

        return "?" + retval;
    }

    @Override
    public void unify(ITermVariableContext other) {
        {
            Map<IBaseExpression<ITrivialExtension>, Map<String, List<IVariable<ITermNonVariableExtension>>>> otherRef
                    = other.getRef();
            for (Entry<IBaseExpression<ITrivialExtension>, Map<String, List<IVariable<ITermNonVariableExtension>>>> otherEntry : otherRef.entrySet()) {
                IBaseExpression<ITrivialExtension> otherKey = otherEntry.getKey();
                Map<String, List<IVariable<ITermNonVariableExtension>>> otherSortRef
                        = otherEntry.getValue();
                if (this.ref.containsKey(otherKey)) {
                    Map<String, List<IVariable<ITermNonVariableExtension>>> thisSortRef
                            = this.ref.get(otherKey);
                    for (Entry<String, List<IVariable<ITermNonVariableExtension>>> otherSEntry : otherSortRef.entrySet()) {
                        String otherSKey = otherSEntry.getKey();
                        List<IVariable<ITermNonVariableExtension>> otherSValue
                                = otherSEntry.getValue();
                        if (thisSortRef.containsKey(otherSKey)) {
                            List<IVariable<ITermNonVariableExtension>> thisSValue
                                    = thisSortRef.get(otherSKey);
                            thisSValue.addAll(otherSValue);
                        } else {
                            thisSortRef.put(otherSKey, otherSValue);
                        }
                    }
                    for (Entry<String, List<IVariable<ITermNonVariableExtension>>> thisSEntry : thisSortRef.entrySet()) {
                        String thisSKey = thisSEntry.getKey();
                        if (!otherSortRef.containsKey(thisSKey)) {
                            otherSortRef.put(thisSKey, thisSEntry.getValue());
                        }
                    }
                } else {
                    this.ref.put(otherKey, otherSortRef);
                }
            }
            for (Entry<IBaseExpression<ITrivialExtension>, Map<String, List<IVariable<ITermNonVariableExtension>>>> thisEntry : this.ref.entrySet()) {
                IBaseExpression<ITrivialExtension> thisKey = thisEntry.getKey();
                if (!otherRef.containsKey(thisKey)) {
                    otherRef.put(thisKey, thisEntry.getValue());
                }
            }
        }
        {
            Map<IVariable<ITermNonVariableExtension>, String> otherBackRef = other.getBackRef();
            for (Entry<IVariable<ITermNonVariableExtension>, String> otherEntry : otherBackRef.entrySet()) {
                this.backRef.put(otherEntry.getKey(), otherEntry.getValue());
            }
            for (Entry<IVariable<ITermNonVariableExtension>, String> thisEntry : this.backRef.entrySet()) {
                IVariable<ITermNonVariableExtension> thisKey = thisEntry.getKey();
                if (!otherBackRef.containsKey(thisKey)) {
                    otherBackRef.put(thisKey, thisEntry.getValue());
                }
            }
        }
        {
            Map<IVariable<ITermNonVariableExtension>, IBaseExpression<ITrivialExtension>> otherSortMap = other.getSortMap();
            for (Entry<IVariable<ITermNonVariableExtension>, IBaseExpression<ITrivialExtension>> otherEntry : otherSortMap.entrySet()) {
                this.sortMap.put(otherEntry.getKey(), otherEntry.getValue());
            }
            for (Entry<IVariable<ITermNonVariableExtension>, IBaseExpression<ITrivialExtension>> thisEntry : this.sortMap.entrySet()) {
                IVariable<ITermNonVariableExtension> thisKey = thisEntry.getKey();
                if (!otherSortMap.containsKey(thisKey)) {
                    otherSortMap.put(thisKey, thisEntry.getValue());
                }
            }
        }
        {
            List<IVariable<ITermNonVariableExtension>> otherUnsortedVariables
                    = other.getUnsortedVariables();
            List<IVariable<ITermNonVariableExtension>> otherUnsortedVariablesCopy
                    = Collections.synchronizedList(new ArrayList<>());
            otherUnsortedVariablesCopy.addAll(otherUnsortedVariables);
            otherUnsortedVariables.addAll(this.unsortedVariables);
            this.unsortedVariables.addAll(otherUnsortedVariablesCopy);
        }
    }

    @Override
    public Map<IVariable<ITermNonVariableExtension>, String> getBackRef() {
        return this.backRef;
    }

    @Override
    public Map<IBaseExpression<ITrivialExtension>, Map<String, List<IVariable<ITermNonVariableExtension>>>> getRef() {
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
    public Map<IVariable<ITermNonVariableExtension>, IBaseExpression<ITrivialExtension>> getSortMap() {
        return this.sortMap;
    }

    @Override
    public List<IVariable<ITermNonVariableExtension>> getUnsortedVariables() {
        return this.unsortedVariables;
    }

    @Override
    public String toString() {
        return "TermVariableContext{" + "backRef=" + backRef + ", ref=" + ref + ", sortMap=" + sortMap + '}';
    }

    @Override
    public void retainAll(Set<IVariable<ITermNonVariableExtension>> vars) {
        {
            Set<IVariable<ITermNonVariableExtension>> invalidVars
                    = Collections.synchronizedSet(this.sortMap.keySet()
                            .parallelStream()
                            .filter(v -> !vars.contains(v))
                            .collect(Collectors.toSet()));
            for (IVariable<ITermNonVariableExtension> var : invalidVars) {
                this.sortMap.remove(var);
            }
        }
        {
            Set<IVariable<ITermNonVariableExtension>> invalidVars
                    = Collections.synchronizedSet(this.backRef.keySet()
                            .parallelStream()
                            .filter(v -> !vars.contains(v))
                            .collect(Collectors.toSet()));
            for (IVariable<ITermNonVariableExtension> var : invalidVars) {
                this.backRef.remove(var);
            }
        }
        {
            Collection<String> names = this.backRef.values();
            for (Map<String, List<IVariable<ITermNonVariableExtension>>> s : this.ref.values()) {
                s.keySet().retainAll(names);
            }
        }
        this.unsortedVariables.retainAll(vars);
        this.ref.values()
                .parallelStream()
                .map(al -> al.values())
                .forEach(al -> al.parallelStream().forEach(bl -> bl.retainAll(vars)));
    }

}
