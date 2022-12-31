/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify3.basic.impl;

import dom.jfischer.probeunify3.basic.IResettable;
import dom.jfischer.probeunify3.basic.IUnification;
import dom.jfischer.probeunify3.exceptions.LengthDoesNotMatchException;
import java.util.List;

/**
 *
 * @author jfischer
 * @param <Type>
 */
public class MultiUnification<Type extends IResettable> implements IUnification<List<Type>> {

    private final IUnification<Type> baseUnification;

    public MultiUnification(IUnification<Type> baseUnification) {
        this.baseUnification = baseUnification;
    }

    @Override
    public boolean unify(List<Type> arg1, List<Type> arg2) {
        int len = arg1.size();
        if (len != arg2.size()) {
            throw new LengthDoesNotMatchException();
        }

        boolean retval = true;
        for (int i = 0; i < len; i++) {
            retval = this.baseUnification.unify(arg1.get(i), arg2.get(i));
            if (!retval) {
                for (int j = 0; j < i; j++) {
                    arg1.get(j).reset();
                    arg2.get(j).reset();
                }
                break;
            }
        }

        return retval;

    }

}
