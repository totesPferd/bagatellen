/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.module.impl;

import dom.jfischer.probeunify2.basic.ICopy;
import dom.jfischer.probeunify2.module.INamedClause;
import dom.jfischer.probeunify2.pel.IPELLeafCollector;
import dom.jfischer.probeunify2.pel.IPELTracker;
import dom.jfischer.probeunify2.pprint.ITermVariableContext;
import dom.jfischer.probeunify2.pprint.impl.TermVariableContextCopy;
import dom.jfischer.probeunify2.proof.IClause;
import dom.jfischer.probeunify2.proof.impl.ClauseCopy;

/**
 *
 * @author jfischer
 */
public class NamedClauseCopy implements ICopy<INamedClause> {

    private final ICopy<IClause> clauseCopier = new ClauseCopy();
    private final ICopy<ITermVariableContext> termVariableContextCopier
            = new TermVariableContextCopy();

    @Override
    public INamedClause copy(IPELTracker tracker, INamedClause object) {
        IClause clauseCopy = this.clauseCopier.copy(tracker, object.getClause());
        ITermVariableContext termVariableContextCopy
                = this.termVariableContextCopier.copy(tracker, object.getTermVariableContext());
        return new NamedClause(clauseCopy, termVariableContextCopy);
    }

    @Override
    public void collectLeafs(IPELLeafCollector leafCollector, INamedClause object) {
        this.clauseCopier.collectLeafs(leafCollector, object.getClause());
        this.termVariableContextCopier.collectLeafs(leafCollector, object.getTermVariableContext());
    }

}
