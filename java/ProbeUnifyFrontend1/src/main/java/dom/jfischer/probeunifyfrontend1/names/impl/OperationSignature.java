/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.names.impl;

import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.IXpr;
import dom.jfischer.probeunifyfrontend1.names.IOperationSignature;
import java.util.List;

/**
 *
 * @author jfischer
 */
public class OperationSignature implements IOperationSignature {

    private final List<IXpr<INonVariableXt>> domain;
    private final IXpr<INonVariableXt> range;

    public OperationSignature(List<IXpr<INonVariableXt>> domain, IXpr<INonVariableXt> range) {
        this.domain = domain;
        this.range = range;
    }

    @Override
    public List<IXpr<INonVariableXt>> getDomain() {
        return this.domain;
    }

    @Override
    public IXpr<INonVariableXt> getRange() {
        return this.range;
    }

}
