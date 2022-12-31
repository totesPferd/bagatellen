/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify3.basic.impl;

import dom.jfischer.probeunify3.basic.IAssumptionsContext;
import dom.jfischer.probeunify3.basic.IClause;
import java.util.List;
import java.util.Optional;

/**
 *
 * @author jfischer
 */
public class AssumptionsContext implements IAssumptionsContext {

    private final IAssumptionsContext parent;
    private final List<IClause> assumptions;

    public AssumptionsContext(List<IClause> assumptions) {
        this.parent = null;
        this.assumptions = assumptions;
    }

    public AssumptionsContext(List<IClause> assumptions, IAssumptionsContext parent) {
        this.parent = parent;
        this.assumptions = assumptions;
    }

    @Override
    public Optional<IAssumptionsContext> getParent() {
        return Optional.ofNullable(this.parent);
    }

    @Override
    public List<IClause> getAssumptions() {
        return this.assumptions;
    }

    @Override
    public void commit() {
        this.assumptions
                .parallelStream()
                .forEach(clause -> clause.commit());
    }

    @Override
    public void reset() {
        this.assumptions
                .parallelStream()
                .forEach(clause -> clause.reset());
    }

}
