/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.basic.impl;

import dom.jfischer.probeunify2.basic.IBaseCopy;
import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ICheckVariableOccurence;
import dom.jfischer.probeunify2.basic.IExtension;
import dom.jfischer.probeunify2.basic.ILeafCollector;
import dom.jfischer.probeunify2.basic.INonVariable;
import dom.jfischer.probeunify2.basic.ITracker;
import dom.jfischer.probeunify2.basic.IUnification;
import dom.jfischer.probeunify2.basic.IVariable;
import java.util.Optional;

/**
 *
 * @author jfischer
 * @param <NonVariableExtension>
 */
public class NonVariable<
        NonVariableExtension extends IExtension> implements
        INonVariable<NonVariableExtension> {

    private final NonVariableExtension nonVariableExtension;
    private final ICheckVariableOccurence<NonVariableExtension> variableOccurenceChecker;
    private final IBaseCopy<NonVariableExtension, NonVariableExtension> nonVariableCopy;
    private final IUnification<NonVariableExtension> nonVariableUnification;

    public NonVariable(NonVariableExtension nonVariableExtension, ICheckVariableOccurence<NonVariableExtension> variableOccurenceChecker, IBaseCopy<NonVariableExtension, NonVariableExtension> nonVariableCopy, IUnification<NonVariableExtension> nonVariableUnification) {
        this.nonVariableExtension = nonVariableExtension;
        this.variableOccurenceChecker = variableOccurenceChecker;
        this.nonVariableCopy = nonVariableCopy;
        this.nonVariableUnification = nonVariableUnification;
    }

    @Override
    public NonVariableExtension getNonVariableExtension() {
        return this.nonVariableExtension;
    }

    @Override
    public Optional<IVariable<NonVariableExtension>> variable() {
        return Optional.empty();
    }

    @Override
    public Optional<INonVariable<NonVariableExtension>> nonVariable() {
        return Optional.of(this);
    }

    @Override
    public IBaseExpression<NonVariableExtension> dereference() {
        return this;
    }

    @Override
    public boolean equateNonVariable(INonVariable<NonVariableExtension> other) {
        return this.nonVariableUnification.unify(this.getNonVariableExtension(), other.getNonVariableExtension());
    }

    @Override
    public void commit() {
        this.nonVariableExtension.commit();
    }

    @Override
    public void reset() {
        this.nonVariableExtension.reset();
    }

    @Override
    public IBaseExpression<NonVariableExtension> copy(ITracker<NonVariableExtension> tracker) {
        IBaseExpression<NonVariableExtension> retval = null;

        Optional<IBaseExpression<NonVariableExtension>> optCopy = tracker.get(this);
        if (optCopy.isPresent()) {
            retval = optCopy.get();
        } else {
            NonVariableExtension nonVariableExtensionCopy
                    = this.nonVariableCopy.copy(tracker, this.nonVariableExtension);
            retval = new NonVariable<>(
                    nonVariableExtensionCopy,
                    this.variableOccurenceChecker,
                    this.nonVariableCopy,
                    this.nonVariableUnification);

            tracker.put(this, retval);
        }

        return retval;
    }

    @Override
    public void collectLeafs(ILeafCollector<NonVariableExtension> leafCollector) {
        this.nonVariableCopy.collectLeafs(leafCollector, this.nonVariableExtension);
    }

    @Override
    public boolean containsVariable(IVariable<NonVariableExtension> variable) {
        return this.variableOccurenceChecker.containsVariable(
                this.getNonVariableExtension(),
                variable);
    }

    @Override
    public boolean isLeaf() {
        return false;
    }

    @Override
    public boolean isDereferenced() {
        return true;
    }

}
