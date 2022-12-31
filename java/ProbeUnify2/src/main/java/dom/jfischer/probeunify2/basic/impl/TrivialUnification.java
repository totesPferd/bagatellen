/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.basic.impl;

import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.basic.IUnification;

/**
 *
 * @author jfischer
 */
public class TrivialUnification implements IUnification<ITrivialExtension> {

    @Override
    public boolean unify(ITrivialExtension arg1, ITrivialExtension arg2) {
        return true;
    }
    
}
