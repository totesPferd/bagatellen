/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.names.impl;

import com.google.common.collect.ListMultimap;
import com.google.common.collect.MultimapBuilder;
import dom.jfischer.probeunify3.basic.ITNonVariableXt;
import dom.jfischer.probeunify3.basic.IVariable;
import dom.jfischer.probeunifyfrontend1.names.IVariableNameInfo;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;

/**
 *
 * @author jfischer
 */
public class VariableNameInfo implements IVariableNameInfo {

    private final ListMultimap<String, IVariable<ITNonVariableXt>> variableNames
            = MultimapBuilder.hashKeys().arrayListValues().build();
    private final List<IVariable<ITNonVariableXt>> unsortedVariables
            = new ArrayList<>();

    @Override
    public ListMultimap<String, IVariable<ITNonVariableXt>> getVariableNames() {
        return this.variableNames;
    }

    @Override
    public List<IVariable<ITNonVariableXt>> getUnsortedVariables() {
        return this.unsortedVariables;
    }

    @Override
    public String getName(IVariable<ITNonVariableXt> variable) {
        String retval = null;

        List<IVariable<ITNonVariableXt>> col = this.unsortedVariables;
        {
            Optional<String> optName = this.variableNames.entries()
                    .stream()
                    .filter(e -> e.getValue() == variable)
                    .map(e -> e.getKey())
                    .findAny();
            if (optName.isPresent()) {
                retval = optName.get();
                col = this.variableNames.get(retval);
            }
        }

        if (!col.contains(variable)) {
            this.unsortedVariables.add(variable);
        }
        if (retval == null) {
            retval = "__";
        }
        if (col.size() != 1) {
            retval += "_" + col.indexOf(variable);
        }

        return "?" + retval;
    }

    @Override
    public void retainAll(Set<IVariable<ITNonVariableXt>> variables) {
        this.variableNames.asMap().values()
                .stream()
                .forEach(l -> l.retainAll(variables));
        this.unsortedVariables.retainAll(variables);
    }

    @Override
    public void addVariable(String name, IVariable<ITNonVariableXt> variable) {
        this.variableNames.put(name, variable);
    }

}
