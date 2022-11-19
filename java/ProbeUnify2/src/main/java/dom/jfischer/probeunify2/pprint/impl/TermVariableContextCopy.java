/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pprint.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ICopy;
import dom.jfischer.probeunify2.basic.ILeafCollector;
import dom.jfischer.probeunify2.basic.ITracker;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.basic.IVariable;
import dom.jfischer.probeunify2.pel.IPELLeafCollector;
import dom.jfischer.probeunify2.pel.IPELTracker;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import dom.jfischer.probeunify2.pprint.ITermVariableContext;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

/**
 *
 * @author jfischer
 */
public class TermVariableContextCopy implements ICopy<ITermVariableContext> {

    @Override
    public ITermVariableContext copy(IPELTracker tracker, ITermVariableContext object) {
        ITermVariableContext retval = new TermVariableContext();
        ITracker<ITermNonVariableExtension> termTracker = tracker.getTermTracker();
        {
            Map<IVariable<ITermNonVariableExtension>, String> otherBackRef = retval.getBackRef();
            Map<IVariable<ITermNonVariableExtension>, IBaseExpression<ITrivialExtension>> otherSortMap = retval.getSortMap();
            for (Map.Entry<IVariable<ITermNonVariableExtension>, String> thisBackRefEntry : object.getBackRef().entrySet()) {
                IVariable<ITermNonVariableExtension> thisVariable = thisBackRefEntry.getKey();
                Optional<IVariable<ITermNonVariableExtension>> optOtherVariable
                        = thisVariable.copy(termTracker).variable();
                if (optOtherVariable.isPresent()) {
                    IVariable<ITermNonVariableExtension> otherVariable = optOtherVariable.get();
                    otherBackRef.put(otherVariable, thisBackRefEntry.getValue());
                    otherSortMap.put(otherVariable, object.getSortMap().get(thisVariable));
                }
            }
        }
        {
            Map<IBaseExpression<ITrivialExtension>, Map<String, List<IVariable<ITermNonVariableExtension>>>> otherRef
                    = retval.getRef();
            for (Map.Entry<IBaseExpression<ITrivialExtension>, Map<String, List<IVariable<ITermNonVariableExtension>>>> thisEntry : object.getRef().entrySet()) {
                Map<String, List<IVariable<ITermNonVariableExtension>>> thisSortRef
                        = thisEntry.getValue();
                Map<String, List<IVariable<ITermNonVariableExtension>>> otherSortRef
                        = new ConcurrentHashMap<>();
                otherRef.put(thisEntry.getKey(), otherSortRef);
                for (Map.Entry<String, List<IVariable<ITermNonVariableExtension>>> thisSEntry : thisSortRef.entrySet()) {
                    String sKey = thisSEntry.getKey();
                    for (IVariable<ITermNonVariableExtension> variable : thisSortRef.get(sKey)) {
                        Optional<IVariable<ITermNonVariableExtension>> optVariableCopy
                                = variable.copy(termTracker).variable();
                        if (optVariableCopy.isPresent()) {
                            IVariable<ITermNonVariableExtension> variableCopy
                                    = optVariableCopy.get();
                            List<IVariable<ITermNonVariableExtension>> otherS
                                    = null;
                            if (otherSortRef.containsKey(sKey)) {
                                otherS = otherSortRef.get(sKey);
                            } else {
                                otherS = Collections.synchronizedList(new ArrayList<>());
                                otherSortRef.put(sKey, otherS);
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
    public void collectLeafs(IPELLeafCollector leafCollector, ITermVariableContext object) {
        ILeafCollector<ITermNonVariableExtension> termLeafCollector = leafCollector.getTermLeafCollector();
        Set<IVariable<ITermNonVariableExtension>> leafs = termLeafCollector.getLeafs();
        object.getBackRef().keySet().forEach(var -> leafs.add(var));
    }

}
