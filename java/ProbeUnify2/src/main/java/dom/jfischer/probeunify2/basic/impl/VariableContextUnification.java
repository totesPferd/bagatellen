/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.basic.impl;

import dom.jfischer.probeunify2.basic.IExtension;
import dom.jfischer.probeunify2.basic.IUnification;
import dom.jfischer.probeunify2.basic.IVariable;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import dom.jfischer.probeunify2.basic.IVariableContext;

/**
 *
 * @author jfischer
 * @param <Extension>
 * @param <NonVariableExtension>
 */
public class VariableContextUnification<Extension extends IExtension, NonVariableExtension extends IExtension> implements
        IUnification<IVariableContext<Extension, NonVariableExtension>> {

    @Override
    public boolean unify(IVariableContext<Extension, NonVariableExtension> arg1, IVariableContext<Extension, NonVariableExtension> arg2) {
        {
            Map<Extension, Map<String, List<IVariable<NonVariableExtension>>>> ref1
                    = arg1.getRef();
            Map<Extension, Map<String, List<IVariable<NonVariableExtension>>>> ref2
                    = arg2.getRef();
            for (Map.Entry<Extension, Map<String, List<IVariable<NonVariableExtension>>>> entry2 : ref2.entrySet()) {
                Extension key2 = entry2.getKey();
                Map<String, List<IVariable<NonVariableExtension>>> sortRef2
                        = entry2.getValue();
                if (ref1.containsKey(key2)) {
                    Map<String, List<IVariable<NonVariableExtension>>> sortRef1
                            = ref1.get(key2);
                    for (Map.Entry<String, List<IVariable<NonVariableExtension>>> sEntry2 : sortRef2.entrySet()) {
                        String sKey2 = sEntry2.getKey();
                        List<IVariable<NonVariableExtension>> sValue2
                                = sEntry2.getValue();
                        if (sortRef1.containsKey(sKey2)) {
                            List<IVariable<NonVariableExtension>> sValue1
                                    = sortRef1.get(sKey2);
                            sValue1.addAll(sValue2);
                        } else {
                            sortRef1.put(sKey2, sValue2);
                        }
                    }
                    sortRef1.entrySet()
                            .parallelStream()
                            .forEach(entry1 -> sortRef2.merge(entry1.getKey(), entry1.getValue(), (u, v) -> u));
                } else {
                    ref1.put(key2, sortRef2);
                }
            }
            for (Map.Entry<Extension, Map<String, List<IVariable<NonVariableExtension>>>> entry1 : ref1.entrySet()) {
                Extension thisKey = entry1.getKey();
                if (!ref2.containsKey(thisKey)) {
                    ref2.put(thisKey, entry1.getValue());
                }
            }
        }
        {
            Map<IVariable<NonVariableExtension>, String> backRef1 = arg1.getBackRef();
            Map<IVariable<NonVariableExtension>, String> backRef2 = arg2.getBackRef();
            backRef2.entrySet()
                    .parallelStream()
                    .forEach(entry2 -> backRef1.put(entry2.getKey(), entry2.getValue()));
            backRef1.entrySet()
                    .parallelStream()
                    .forEach(entry1 -> backRef2.merge(entry1.getKey(), entry1.getValue(), (u, v) -> u));
        }
        {
            Map<IVariable<NonVariableExtension>, Extension> extensionMap1
                    = arg1.getExtensionMap();
            Map<IVariable<NonVariableExtension>, Extension> extensionMap2
                    = arg2.getExtensionMap();
            extensionMap2.entrySet()
                    .parallelStream()
                    .forEach(entry2 -> extensionMap1.put(entry2.getKey(), entry2.getValue()));
            extensionMap1.entrySet()
                    .parallelStream()
                    .forEach(entry1 -> extensionMap2.merge(entry1.getKey(), entry1.getValue(), (u, v) -> u));
        }
        {
            List<IVariable<NonVariableExtension>> unsortedVariables1
                    = arg1.getUnsortedVariables();
            List<IVariable<NonVariableExtension>> unsortedVariables2
                    = arg2.getUnsortedVariables();

            List<IVariable<NonVariableExtension>> unsortedVariables2Copy
                    = Collections.synchronizedList(unsortedVariables2
                            .parallelStream()
                            .filter(v -> !unsortedVariables1.contains(v))
                            .collect(Collectors.toList()));
            unsortedVariables1
                    .parallelStream()
                    .filter(v -> !unsortedVariables2.contains(v))
                    .forEach(v -> unsortedVariables2.add(v));
            unsortedVariables1.addAll(unsortedVariables2Copy);
        }

        return true;
    }

}
