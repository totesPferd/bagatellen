/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.basic.impl;

import dom.jfischer.probeunify2.basic.IExtension;
import dom.jfischer.probeunify2.basic.IUnification;
import dom.jfischer.probeunify2.exception.LengthDoesNotMatchException;
import java.util.List;

/**
 *
 * @author jfischer
 * @param <Base>
 */
public class MultiUnification<Base extends IExtension> implements
        IUnification<List<Base>> {

    private final IUnification<Base> singleUnification;

    public MultiUnification(IUnification<Base> singleUnification) {
        this.singleUnification = singleUnification;
    }

    @Override
    public boolean unify(List<Base> arg1, List<Base> arg2) {
        int len = arg1.size();
        if (len != arg2.size()) {
            throw new LengthDoesNotMatchException();
        }

        boolean retval = true;
        for (int i = 0; i < len; i++) {
            retval = this.singleUnification.unify(arg1.get(i), arg2.get(i));
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
