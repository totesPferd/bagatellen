/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2.pprint;

/**
 *
 * @author jfischer
 */
public interface IConstructionPPrint extends IPPrintAble {

    String getSingleLine();

    void pprintMultiLine(IPPrintBase pprintBase);

    @Override
    default void pprint(IPPrintBase pprintBase) {
        String singleLine = this.getSingleLine();
        if (pprintBase.getRemainingLineWidth() < singleLine.length()) {
            pprintMultiLine(pprintBase);
        } else {
            pprintBase.printToken(singleLine);
        }
    }

}
