/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pprint.impl;

import dom.jfischer.probeunify2.pprint.IPPrintBase;
import dom.jfischer.probeunify2.pprint.IPPrintConfig;
import dom.jfischer.probeunify2.pprint.WhiteSpaceReqType;
import static dom.jfischer.probeunify2.pprint.WhiteSpaceReqType.FORCED_NEED;
import static dom.jfischer.probeunify2.pprint.WhiteSpaceReqType.NEEDS_BIG_WS;
import static dom.jfischer.probeunify2.pprint.WhiteSpaceReqType.NEEDS_SMALL_WS;
import static dom.jfischer.probeunify2.pprint.WhiteSpaceReqType.NO_NEED;
import java.io.PrintStream;

/**
 *
 * @author jfischer
 */
public class PPrintBase implements IPPrintBase {

    private final PrintStream outStream;
    private final IPPrintConfig config;

    private int column = 1;
    private int indent;
    private WhiteSpaceReqType whiteSpaceReqType = NO_NEED;
    private String outstandingText = null;

    public PPrintBase(PrintStream outStream, IPPrintConfig config, int indent) {
        this.outStream = outStream;
        this.config = config;
        this.indent = indent;
    }

    @Override
    public void setDeeperIndent() {
        this.indent += this.config.getIndent();
    }

    @Override
    public void restoreIndent() {
        this.indent -= this.config.getIndent();
    }

    @Override
    public void forceWhiteSpace() {
        this.whiteSpaceReqType = FORCED_NEED;
    }

    @Override
    public int getRemainingLineWidth() {
        return this.config.getPageWidth() - this.column;
    }

    @Override
    public int getRemainingLineWidthAfterIndent() {
        return this.config.getPageWidth() - this.indent;
    }

    @Override
    public void navigateToPos(int pos) {
        while (this.column != pos) {
            if (this.column > pos) {
                this.printNewLine();
            } else {
                this.printWhiteSpace(" ");
            }
        }
    }

    @Override
    public void navigateToRelPos(int pos) {
        this.navigateToPos(this.indent + pos);
    }

    @Override
    public void printNewLine() {
        this.outStream.println();
        this.column = this.indent;
        this.whiteSpaceReqType = NO_NEED;
        this.outstandingText = " ".repeat(this.indent);
    }

    @Override
    public void printOpeningParenthesis(String parenthesis) {
        this.printParenthesisWithBigAndSmallWhiteSpace(parenthesis);
        this.whiteSpaceReqType = NO_NEED;
    }

    @Override
    public void printClosingParenthesis(String parenthesis) {
        this.printParenthesisWithBigAndSmallWhiteSpace(parenthesis);
        this.whiteSpaceReqType = NEEDS_SMALL_WS;
    }

    @Override
    public void printWhiteSpace(String whiteSpace) {
        if (this.outstandingText == null) {
            this.outstandingText = "";
        }
        this.outstandingText += whiteSpace;
        this.column += whiteSpace.length();
        this.whiteSpaceReqType = NO_NEED;
    }

    @Override
    public void printToken(String token) {
        this.printTokenWithBigAndSmallWhiteSpace(token);
        this.whiteSpaceReqType = NEEDS_SMALL_WS;
    }

    @Override
    public void printAssignToken(String assignToken) {
        this.printTokenWithBigAndSmallWhiteSpace(assignToken);
        this.whiteSpaceReqType = NEEDS_BIG_WS;
    }

    @Override
    public void printPeriod(String period) {
        this.printParenthesisWithBigAndSmallWhiteSpace(period);
        this.whiteSpaceReqType = NEEDS_BIG_WS;
    }

    private void printDirectly(String data) {
        if (this.outstandingText != null) {
            this.outStream.print(this.outstandingText);
            this.outstandingText = null;
        }
        this.outStream.print(data);
        this.column += data.length();
    }

    private void printBigAndSmallWhiteSpace() {
        this.printWhiteSpace(this.whiteSpaceReqType == NEEDS_BIG_WS ? "  " : " ");
    }

    private void checkLineExceed(String data) {
        if (this.column + data.length() > this.config.getPageWidth()) {
            this.printNewLine();
        }
    }

    private void printParenthesisWithBigAndSmallWhiteSpace(String parenthesis) {
        this.checkLineExceed(parenthesis);
        if (this.whiteSpaceReqType == FORCED_NEED) {
            this.printBigAndSmallWhiteSpace();
        }
        this.printDirectly(parenthesis);
    }

    private void printTokenWithBigAndSmallWhiteSpace(String token) {
        this.checkLineExceed(token);
        if (this.whiteSpaceReqType != NO_NEED) {
            this.printBigAndSmallWhiteSpace();
        }
        this.printDirectly(token);
    }

}
