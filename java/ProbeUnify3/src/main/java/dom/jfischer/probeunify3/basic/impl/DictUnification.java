/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify3.basic.impl;

import dom.jfischer.probeunify3.basic.IResettable;
import dom.jfischer.probeunify3.basic.IUnification;
import java.util.Map;
import java.util.Map.Entry;

/**
 *
 * @author jfischer
 * @param <Key>
 * @param <Base>
 */
public class DictUnification<Key, Base extends IResettable> implements
        IUnification<Map<Key, Base>> {

    private final IUnification<Base> baseUnification;

    public DictUnification(IUnification<Base> baseUnification) {
        this.baseUnification = baseUnification;
    }

    @Override
    public boolean unify(Map<Key, Base> arg1, Map<Key, Base> arg2) {
        boolean retval = true;

        for (Entry<Key, Base> entry : arg1.entrySet()) {
            Key key1 = entry.getKey();
            Base value1 = entry.getValue();
            if (arg2.containsKey(key1)) {
                retval = this.baseUnification.unify(value1, arg2.get(key1));
                if (!retval) {
                    for (Entry<Key, Base> resetEntry : arg1.entrySet()) {
                        Key resetKey = resetEntry.getKey();
                        if (arg2.containsKey(resetKey)) {
                            arg1.get(resetKey).reset();
                            arg2.get(resetKey).reset();
                        }
                    }
                    break;
                }
            }
            if (!retval) {
                break;
            }
        }
        if (retval) {
            for (Entry<Key, Base> entry : arg1.entrySet()) {
                Key key1 = entry.getKey();
                if (!arg2.containsKey(key1)) {
                    arg2.put(key1, entry.getValue());
                }
            }
            for (Entry<Key, Base> entry : arg2.entrySet()) {
                Key key1 = entry.getKey();
                if (!arg1.containsKey(key1)) {
                    arg1.put(key1, entry.getValue());
                }
            }
        }

        return retval;

    }

}
