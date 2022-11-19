/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Exception.java to edit this template
 */
package dom.jfischer.probeunify2.exception;

import java.util.List;

/**
 *
 * @author jfischer
 */
public class QualificatorException extends Exception {

    private final List<String> qualificator;

    /**
     * Creates a new instance of <code>QualificatorException</code> without
     * detail message.
     */
    public QualificatorException() {
        this.qualificator = null;
    }

    /**
     * Constructs an instance of <code>QualificatorException</code> with the
     * specified detail message.
     *
     * @param qualificator
     */
    public QualificatorException(List<String> qualificator) {
        super("qualificator " + String.join(".", qualificator) + "does not point to no module.");
        this.qualificator = qualificator;
    }

    public List<String> getQualificator() {
        return qualificator;
    }

}
