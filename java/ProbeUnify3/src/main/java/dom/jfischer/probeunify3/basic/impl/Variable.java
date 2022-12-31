/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify3.basic.impl;

import dom.jfischer.probeunify3.basic.ILeafCollector;
import dom.jfischer.probeunify3.basic.INonVariable;
import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.IVariable;
import dom.jfischer.probeunify3.basic.IXpr;
import java.util.Optional;
import java.util.Set;

/**
 *
 * @author jfischer
 * @param <NonVariableXt>
 */
public class Variable<NonVariableXt extends INonVariableXt> implements
        IVariable<NonVariableXt> {

    private IXpr<NonVariableXt> variable = null;
    private boolean isOpen = false;

    @Override
    public void clear() {
        this.variable = null;
        this.isOpen = false;
    }

    @Override
    public void setValue(IXpr<NonVariableXt> value) {
        if (this != value) {
            this.variable = value;
        }
        this.isOpen = true;

    }

    @Override
    public IXpr<NonVariableXt> dereference() {
        return this.variable == null ? this : this.variable.dereference();
    }

    @Override
    public Optional<IVariable<NonVariableXt>> variable() {
        return Optional.of(this);
    }

    @Override
    public Optional<INonVariable<NonVariableXt>> nonVariable() {
        return Optional.empty();
    }

    @Override
    public boolean equateNonVariable(INonVariable<NonVariableXt> nonVariable) {
        boolean retval = !nonVariable.containsVariable(this);

        if (retval) {
            this.setValue(nonVariable);
        }

        return retval;
    }

    @Override
    public void commit() {
        if (this.variable != null && !this.isOpen) {
            this.variable.commit();
        } else if (this.isOpen) {
            this.isOpen = false;
        }
    }

    @Override
    public void reset() {
        if (this.variable != null && !this.isOpen) {
            this.variable.reset();
        } else if (this.isOpen) {
            this.variable = null;
            this.isOpen = false;
        }
    }

    @Override
    public boolean containsVariable(IVariable<NonVariableXt> variable) {
        return this.dereference() == variable;
    }

    @Override
    public void collectLeafs(ILeafCollector<NonVariableXt> leafCollector) {
        if (this.variable == null) {
            Set<IVariable<NonVariableXt>> leafs = leafCollector.getLeafs();
            leafs.add(this);
        } else {
            this.variable.collectLeafs(leafCollector);
        }

    }

    @Override
    public boolean isLeaf() {
        return this.variable == null;
    }

}
