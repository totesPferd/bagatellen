/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.names.impl;

import dom.jfischer.probeunifyfrontend1.names.IIndexedSymbolBean;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *
 * @author jfischer
 */
public class IndexedSymbolBean extends BaseSymbolBean implements IIndexedSymbolBean {

    private Integer index;

    public IndexedSymbolBean() {
        super(Pattern.compile("^\\?(__|[A-Za-z_][A-Za-z0-9]*)_([0-9]+)$"));
    }
    
    @Override
    public Integer getIndex() {
        return this.index;
    }

    @Override
    public void setIndex(Integer index) {
        this.index = index;
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
            this.index =  Integer.parseInt(m.group(2));
        }
        
        return retval;
    }
    
}
