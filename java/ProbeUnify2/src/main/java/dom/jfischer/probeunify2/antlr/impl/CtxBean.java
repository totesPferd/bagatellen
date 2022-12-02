/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.antlr.impl;

import dom.jfischer.probeunify2.pel.IPELVariableContext;
import java.io.Serializable;

/**
 *
 * @author jfischer
 */
public class CtxBean implements Serializable {

    private LiteralVariableInfo literalVariableInfo;

    private IPELVariableContext pelVariableContext;

    public LiteralVariableInfo getLiteralVariableInfo() {
        return literalVariableInfo;
    }

    public void setLiteralVariableInfo(LiteralVariableInfo literalVariableInfo) {
        this.literalVariableInfo = literalVariableInfo;
    }

    public IPELVariableContext getPelVariableContext() {
        return pelVariableContext;
    }

    public void setPelVariableContext(IPELVariableContext pelVariableContext) {
        this.pelVariableContext = pelVariableContext;
    }

}
