/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ICopy;
import dom.jfischer.probeunify2.basic.IExpression;
import dom.jfischer.probeunify2.module.IModule;
import dom.jfischer.probeunify2.pel.INamedClause;
import dom.jfischer.probeunify2.module.impl.Module;
import dom.jfischer.probeunify2.module.impl.ModuleHelper;
import dom.jfischer.probeunify2.pel.impl.NamedClauseCopy;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.IPELLeafCollector;
import dom.jfischer.probeunify2.pel.impl.LiteralCopy;
import dom.jfischer.probeunify2.pel.impl.PELLeafCollector;
import dom.jfischer.probeunify2.pprint.IBackReference;
import dom.jfischer.probeunify2.pprint.impl.BackReference;
import dom.jfischer.probeunify2.proof.IGoalExtension;
import dom.jfischer.probeunify2.proof.IGoalNonVariableExtension;
import dom.jfischer.probeunify2.proof.impl.ProofHelper;

/**
 *
 * @author jfischer
 */
public class Cmdline implements ICmdline {

    private final IModule module = new Module();
    private final ICopy<INamedClause> namedClauseCopier;

    private INamedClause conjecture;
    private String moduleName;
    private IState state = null;

    public Cmdline() {
        ICopy<IBaseExpression<ILiteralNonVariableExtension>> goalCopier
                = new LiteralCopy();
        this.namedClauseCopier = new NamedClauseCopy(goalCopier);
    }

    @Override
    public IModule getModule() {
        return this.module;
    }

    @Override
    public IState getState() {
        if (this.state == null) {
            IBackReference backReference = new BackReference();
            ModuleHelper.getBackReference(this.module, backReference, null);
            IExpression<IGoalExtension, IGoalNonVariableExtension> goal
                    = ProofHelper.createGoal(this.conjecture.getClause().getConclusion());
            IPELLeafCollector leafCollector = new PELLeafCollector();
            this.namedClauseCopier.collectLeafs(leafCollector, this.conjecture);
            this.state = new State(this.module, backReference, leafCollector, this.moduleName, conjecture, goal);
        }
        return this.state;
    }

    @Override
    public void setConjecture(INamedClause conjecture) {
        this.conjecture = conjecture;
    }

    @Override
    public void setModuleName(String moduleName) {
        this.moduleName = moduleName;
    }

    @Override
    public void setState(IState state) {
        this.state = state;
    }

}
