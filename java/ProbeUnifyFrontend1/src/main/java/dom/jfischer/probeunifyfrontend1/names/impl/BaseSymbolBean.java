/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.names.impl;

import dom.jfischer.probeunifyfrontend1.names.IBaseSymbolBean;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *
 * @author jfischer
 */
public class BaseSymbolBean implements IBaseSymbolBean {

    protected final Pattern variablePattern;
    
    protected String symbol;

    public BaseSymbolBean() {
        this.variablePattern =  Pattern.compile("^\\?(__|[A-Za-z_][A-Za-z0-9]*)$");
    }

    public BaseSymbolBean(Pattern variablePattern) {
        this.variablePattern = variablePattern;
    }

    @Override
    public String getSymbol() {
        return this.symbol;
    }

    @Override
    public void setSymbol(String symbol) {
        this.symbol = symbol;
    }

    @Override
    public boolean parseName(String name) {
        Matcher m =  this.variablePattern.matcher(name);
        boolean retval =  m.matches();
        
        if (retval) {
            this.symbol =  m.group(1);
            if (this.symbol.equals("__")) {
                this.symbol =  "_";
            }
        }
        
        return retval;
    }

}
