/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.pph.impl;

import dom.jfischer.pph.IConstructionPPrint;
import dom.jfischer.pph.IPPrintBase;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 *
 * @author jfischer
 */
public class EnumerationConstructionPPrint implements IConstructionPPrint {

    private final String delimiter;
    private final List<IConstructionPPrint> data;

    public EnumerationConstructionPPrint(String delimiter, List<IConstructionPPrint> data) {
        this.delimiter = delimiter;
        this.data = data;
    }

    @Override
    public String getSingleLine() {
        List<String> outData
                = Collections.synchronizedList(this.data
                        .parallelStream()
                        .map(item -> item.getSingleLine())
                        .collect(Collectors.toList()));
        return String.join(this.delimiter + " ", outData);
    }

    @Override
    public void pprintMultiLine(IPPrintBase pprintBase) {
        for (int i = 0; i < this.data.size(); i++) {
            pprintBase.navigateToRelPos(0);
            if (i != 0) {
                pprintBase.printClosingParenthesis(this.delimiter);
            }
            pprintBase.setDeeperIndent();
            pprintBase.navigateToRelPos(0);
            this.data.get(i).pprint(pprintBase);
            pprintBase.restoreIndent();
        }
        pprintBase.forceWhiteSpace();
    }

}
