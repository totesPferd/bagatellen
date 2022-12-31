/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.pph;

/**
 *
 * @author jfischer
 */
public interface IPPrintBase {

    void setDeeperIndent();

    void restoreIndent();

    void forceWhiteSpace();

    int getRemainingLineWidth();

    int getRemainingLineWidthAfterIndent();

    void navigateToPos(int pos);

    void navigateToRelPos(int pos);

    void printNewLine();

    void printOpeningParenthesis(String parenthesis);

    void printClosingParenthesis(String parenthesis);

    void printWhiteSpace(String whiteSpace);

    void printToken(String token);

    void printAssignToken(String assignToken);

    void printPeriod(String period);

}
