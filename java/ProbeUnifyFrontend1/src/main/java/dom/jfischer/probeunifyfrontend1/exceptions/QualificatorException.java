/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Exception.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.exceptions;

/**
 *
 * @author jfischer
 */
public class QualificatorException extends RuntimeException {

    /**
     * Creates a new instance of <code>QualificatorException</code> without
     * detail message.
     */
    public QualificatorException() {
        super("qualificator does not point to anything.");
    }

    /**
     * Constructs an instance of <code>QualificatorException</code> with the
     * specified detail message.
     *
     * @param msg the detail message.
     */
    public QualificatorException(String msg) {
        super("qualificator does not point to anything: " + msg);
    }
}
