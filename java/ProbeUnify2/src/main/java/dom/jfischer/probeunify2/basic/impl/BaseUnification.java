/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.basic.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.IExtension;
import dom.jfischer.probeunify2.basic.INonVariable;
import dom.jfischer.probeunify2.basic.IUnification;
import dom.jfischer.probeunify2.basic.IVariable;
import java.util.Optional;

/**
 *
 * @author jfischer
 * @param <NonVariableExtension>
 */
public class BaseUnification<
        NonVariableExtension extends IExtension> implements
        IUnification<IBaseExpression<NonVariableExtension>> {

    @Override
    public boolean unify(IBaseExpression<NonVariableExtension> arg1, IBaseExpression<NonVariableExtension> arg2) {
        IBaseExpression<NonVariableExtension> dereferencedArg1 = arg1.dereference();
        IBaseExpression<NonVariableExtension> dereferencedArg2 = arg2.dereference();
        boolean retval = dereferencedArg1 == dereferencedArg2;

        if (!retval) {
            {
                Optional<INonVariable<NonVariableExtension>> optNonVariable = dereferencedArg1.nonVariable();
                if (optNonVariable.isPresent()) {
                    retval = dereferencedArg2.equateNonVariable(optNonVariable.get());
                }
            }
            {
                Optional<IVariable<NonVariableExtension>> optVariable1 = dereferencedArg1.variable();
                if (optVariable1.isPresent()) {
                    IVariable<NonVariableExtension> variable1 = optVariable1.get();
                    if (dereferencedArg2.containsVariable(variable1)) {
                        retval = false;
                    } else {
                        retval = true;
                        variable1.setValue(dereferencedArg2);
                    }
                }
            }

            if (!retval) {
                dereferencedArg2.reset();
                dereferencedArg1.reset();
            }
        }

        return retval;
    }

}
