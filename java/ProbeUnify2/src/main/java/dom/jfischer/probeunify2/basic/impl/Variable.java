/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.basic.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.IExtension;
import dom.jfischer.probeunify2.basic.ILeafCollector;
import dom.jfischer.probeunify2.basic.INonVariable;
import dom.jfischer.probeunify2.basic.ITracker;
import dom.jfischer.probeunify2.basic.IVariable;
import dom.jfischer.probeunify2.exception.VariableSetException;
import java.util.Optional;
import java.util.Set;

/**
 *
 * @author jfischer
 * @param <NonVariableExtension>
 */
public class Variable<
        NonVariableExtension extends IExtension> implements
        IVariable<NonVariableExtension> {

    private IBaseExpression<NonVariableExtension> variable = null;
    private boolean isOpen = false;
    private boolean isOpenRecurse = false;

    @Override
    public void clear() {
        this.variable = null;
    }

    @Override
    public Optional<IBaseExpression<NonVariableExtension>> value() {
        return Optional.ofNullable(this.variable);
    }

    @Override
    public void setValue(IBaseExpression<NonVariableExtension> value) {
        if (this.variable == null) {
            IBaseExpression<NonVariableExtension> actualValue
                    = value.dereference();
            if (this != actualValue) {
                this.variable = actualValue;
            }
            this.isOpen = true;
        } else {
            throw new VariableSetException();
        }
    }

    @Override
    public Optional<IVariable<NonVariableExtension>> variable() {
        return Optional.of(this);
    }

    @Override
    public Optional<INonVariable<NonVariableExtension>> nonVariable() {
        return Optional.empty();
    }

    @Override
    public boolean equateNonVariable(INonVariable<NonVariableExtension> other) {
        boolean retval = true;

        if (this.variable == null) {
            if (other.containsVariable(this)) {
                retval = false;
            } else {
                this.setValue(other);
            }
        } else {
            retval = this.variable.equateNonVariable(other);
            this.isOpenRecurse = true;
        }

        return retval;
    }

    @Override
    public IBaseExpression<NonVariableExtension> dereference() {
        return this.variable == null ? this : this.variable.dereference();
    }

    @Override
    public void commit() {
        if (this.isOpenRecurse && this.variable != null) {
            this.variable.commit();
            this.isOpenRecurse = false;
        }
        this.isOpen = false;
    }

    @Override
    public void reset() {
        if (this.isOpenRecurse && this.variable != null) {
            this.variable.reset();
            this.isOpenRecurse = false;
        }
        if (this.isOpen) {
            this.variable = null;
            this.isOpen = false;
        }
    }

    @Override
    public IBaseExpression<NonVariableExtension> copy(ITracker<NonVariableExtension> tracker) {
        IBaseExpression<NonVariableExtension> retval = null;

        Optional<IBaseExpression<NonVariableExtension>> optCopy = tracker.get(this);
        if (optCopy.isPresent()) {
            retval = optCopy.get();
        } else {
            if (this.variable == null) {
                retval = new Variable<>();
            } else {
                retval = this.variable.copy(tracker);
            }

            tracker.put(this, retval);
        }

        return retval;
    }

    @Override
    public void collectLeafs(ILeafCollector<NonVariableExtension> leafCollector) {
        if (this.variable == null) {
            Set<IVariable<NonVariableExtension>> leafs = leafCollector.getLeafs();
            leafs.add(this);
        } else {
            this.variable.collectLeafs(leafCollector);
        }
    }

    @Override
    public boolean containsVariable(IVariable<NonVariableExtension> variable) {
        return this.dereference() == variable;
    }

}
