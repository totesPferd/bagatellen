/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.module.impl;

import dom.jfischer.probeunify2.basic.IUnification;
import dom.jfischer.probeunify2.module.INamedClause;
import dom.jfischer.probeunify2.proof.IClause;
import dom.jfischer.probeunify2.proof.impl.ClauseUnification;

/**
 *
 * @author jfischer
 */
public class NamedClauseUnification implements IUnification<INamedClause> {

    private final IUnification<IClause> clauseUnification
            = new ClauseUnification();

    @Override
    public boolean unify(INamedClause arg1, INamedClause arg2) {
        boolean retval = this.clauseUnification.unify(arg1.getClause(), arg2.getClause());
        if (retval) {
            arg1.getTermVariableContext().unify(arg2.getTermVariableContext());
        }
        return retval;
    }

}
