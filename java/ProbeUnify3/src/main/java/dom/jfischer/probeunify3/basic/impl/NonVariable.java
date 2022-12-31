/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify3.basic.impl;

import dom.jfischer.probeunify3.basic.ICheckVariableOccurence;
import dom.jfischer.probeunify3.basic.ILeafCollecting;
import dom.jfischer.probeunify3.basic.ILeafCollector;
import dom.jfischer.probeunify3.basic.INonVariable;
import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.IUnification;
import dom.jfischer.probeunify3.basic.IVariable;
import dom.jfischer.probeunify3.basic.IXpr;
import java.util.Optional;

/**
 *
 * @author jfischer
 * @param <NonVariableXt>
 */
public class NonVariable<NonVariableXt extends INonVariableXt> implements
        INonVariable<NonVariableXt> {

    private final ICheckVariableOccurence<NonVariableXt, NonVariableXt> variableOccurenceChecker;
    private final ILeafCollecting<NonVariableXt, NonVariableXt> leafCollector;
    private final IUnification<NonVariableXt> nonVariableXtUnification;
    private final NonVariableXt nonVariableXt;

    public NonVariable(ICheckVariableOccurence<NonVariableXt, NonVariableXt> variableOccurenceChecker, ILeafCollecting<NonVariableXt, NonVariableXt> leafCollector, IUnification<NonVariableXt> nonVariableXtUnification, NonVariableXt nonVariableXt) {
        this.variableOccurenceChecker = variableOccurenceChecker;
        this.leafCollector = leafCollector;
        this.nonVariableXtUnification = nonVariableXtUnification;
        this.nonVariableXt = nonVariableXt;
    }

 
    
    @Override
    public NonVariableXt getNonVariableXt() {
        return this.nonVariableXt;
    }

    @Override
    public IXpr<NonVariableXt> dereference() {
        return this;
    }

    @Override
    public Optional<IVariable<NonVariableXt>> variable() {
        return Optional.empty();
    }

    @Override
    public Optional<INonVariable<NonVariableXt>> nonVariable() {
        return Optional.of(this);
    }

    @Override
    public boolean equateNonVariable(INonVariable<NonVariableXt> nonVariable) {
        return this.nonVariableXtUnification.unify(
                this.nonVariableXt,
                nonVariable.getNonVariableXt());
    }

    @Override
    public void commit() {
        this.nonVariableXt.commit();
    }

    @Override
    public void reset() {
        this.nonVariableXt.reset();
    }

    @Override
    public boolean containsVariable(IVariable<NonVariableXt> variable) {
        return this.variableOccurenceChecker.containsVariable(this.nonVariableXt, variable);
    }

    @Override
    public void collectLeafs(ILeafCollector<NonVariableXt> leafCollector) {
        this.leafCollector.collectLeafs(leafCollector, this.nonVariableXt);
    }

    @Override
    public boolean isLeaf() {
        return true;
    }

}
