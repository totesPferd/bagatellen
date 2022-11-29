/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pprint.impl;

import dom.jfischer.probeunify2.pel.INamedTerm;
import dom.jfischer.probeunify2.pprint.IBackReference;

/**
 *
 * @author jfischer
 */
public class TermConstructionPPrint extends TermBaseConstructionPPrint {

    public TermConstructionPPrint(IBackReference backRef, INamedTerm nterm) {
        super(
                backRef,
                nterm.getTermVariableContext(),
                nterm.getTerm());
    }

}
