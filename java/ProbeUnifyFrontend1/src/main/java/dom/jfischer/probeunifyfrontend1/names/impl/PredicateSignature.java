/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.names.impl;

import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.IXpr;
import dom.jfischer.probeunifyfrontend1.names.IPredicateSignature;
import java.util.List;

/**
 *
 * @author jfischer
 */
public class PredicateSignature implements IPredicateSignature {

    private final List<IXpr<INonVariableXt>> domain;

    public PredicateSignature(List<IXpr<INonVariableXt>> domain) {
        this.domain = domain;
    }

    @Override
    public List<IXpr<INonVariableXt>> getDomain() {
        return this.domain;
    }

}
