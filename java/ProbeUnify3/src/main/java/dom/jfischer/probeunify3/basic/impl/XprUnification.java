/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify3.basic.impl;

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
public class XprUnification<NonVariableXt extends INonVariableXt> implements
        IUnification<IXpr<NonVariableXt>> {

    @Override
    public boolean unify(IXpr<NonVariableXt> arg1, IXpr<NonVariableXt> arg2) {
        IXpr<NonVariableXt> dereferencedArg1 = arg1.dereference();
        IXpr<NonVariableXt> dereferencedArg2 = arg2.dereference();

        boolean retval = dereferencedArg1 == dereferencedArg2;

        if (!retval) {
            {
                Optional<INonVariable<NonVariableXt>> optNonVariable1
                        = dereferencedArg1.nonVariable();
                if (optNonVariable1.isPresent()) {
                    INonVariable<NonVariableXt> nonVariable1
                            = optNonVariable1.get();
                    retval = dereferencedArg2.equateNonVariable(nonVariable1);
                }
            }
            {
                Optional<IVariable<NonVariableXt>> optVariable1 = dereferencedArg1.variable();
                if (optVariable1.isPresent()) {
                    IVariable<NonVariableXt> variable1 = optVariable1.get();
                    retval = !dereferencedArg2.containsVariable(variable1);
                    if (retval) {
                        variable1.setValue(dereferencedArg2);
                    }
                }
            }

        }
        
        if (!retval) {
            dereferencedArg1.reset();
            dereferencedArg2.reset();
        }

        return retval;

    }

}
