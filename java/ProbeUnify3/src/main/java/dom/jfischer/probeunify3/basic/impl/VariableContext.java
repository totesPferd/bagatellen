/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify3.basic.impl;

import dom.jfischer.probeunify3.basic.ICopy;
import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.ITracker;
import dom.jfischer.probeunify3.basic.IVariable;
import dom.jfischer.probeunify3.basic.IVariableContext;
import dom.jfischer.probeunify3.basic.IXpr;
import java.util.Collections;
import java.util.HashSet;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

/**
 *
 * @author jfischer
 * @param <NonVariableXt>
 */
public class VariableContext<NonVariableXt extends INonVariableXt> implements
        IVariableContext<NonVariableXt> {

    private final IVariableContext<NonVariableXt> parent;
    private final Set<IVariable<NonVariableXt>> variables;

    private final ICopy<IXpr<NonVariableXt>, ITracker<IXpr<NonVariableXt>>> baseCopier;
    private final ICopy<IVariable<NonVariableXt>, ITracker<IXpr<NonVariableXt>>> variableCopier;

    public VariableContext(ICopy<IXpr<NonVariableXt>, ITracker<IXpr<NonVariableXt>>> baseCopier) {
        this.parent = null;
        this.variables = Collections.synchronizedSet(new HashSet<>());
        this.baseCopier = baseCopier;
        this.variableCopier = new VariableCopy<>(baseCopier);
    }

    public VariableContext(IVariableContext<NonVariableXt> parent, ICopy<IXpr<NonVariableXt>, ITracker<IXpr<NonVariableXt>>> baseCopier) {
        this.parent = parent;
        this.variables = Collections.synchronizedSet(new HashSet<>());
        this.baseCopier = baseCopier;
        this.variableCopier = new VariableCopy<>(baseCopier);

    }

    public VariableContext(IVariableContext<NonVariableXt> parent, Set<IVariable<NonVariableXt>> variables, ICopy<IXpr<NonVariableXt>, ITracker<IXpr<NonVariableXt>>> baseCopier) {
        this.parent = parent;
        this.variables = variables;
        this.baseCopier = baseCopier;
        this.variableCopier = new VariableCopy<>(baseCopier);
    }

    @Override
    public Optional<IVariableContext<NonVariableXt>> getParent() {
        return Optional.ofNullable(this.parent);
    }

    @Override
    public Set<IVariable<NonVariableXt>> getVariables() {
        return this.variables;
    }

    @Override
    public IVariableContext<NonVariableXt> copy(ITracker<IXpr<NonVariableXt>> tracker) {
        Set<IVariable<NonVariableXt>> variablesCopy = Collections.synchronizedSet(this.variables
                .parallelStream()
                .map(var -> this.variableCopier.copy(tracker, var))
                .collect(Collectors.toSet()));
        return new VariableContext<>(
                this.parent,
                variablesCopy,
                this.baseCopier
        );
    }

    @Override
    public IVariable<NonVariableXt> createVariable() {
        IVariable<NonVariableXt> retval =  new Variable<>();
        this.variables.add(retval);
        return retval;
    }

}
