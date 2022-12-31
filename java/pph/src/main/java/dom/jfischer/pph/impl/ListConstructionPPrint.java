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
public class ListConstructionPPrint implements IConstructionPPrint {

    private final List<IConstructionPPrint> data;

    public ListConstructionPPrint(List<IConstructionPPrint> data) {
        this.data = data;
    }

    @Override
    public String getSingleLine() {
        List<String> outData
                = Collections.synchronizedList(this.data
                        .parallelStream()
                        .map(item -> item.getSingleLine())
                        .collect(Collectors.toList()));
        return String.join(" ", outData);
    }

    @Override
    public void pprintMultiLine(IPPrintBase pprintBase) {
        pprintBase.setDeeperIndent();
        for (IConstructionPPrint item : this.data) {
            pprintBase.navigateToRelPos(0);
            item.pprint(pprintBase);
        }
        pprintBase.restoreIndent();
        pprintBase.forceWhiteSpace();
    }

}
