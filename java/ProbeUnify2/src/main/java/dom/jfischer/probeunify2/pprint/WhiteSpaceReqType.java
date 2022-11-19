/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Enum.java to edit this template
 */
package dom.jfischer.probeunify2.pprint;

/**
 *
 * @author jfischer
 */
public enum WhiteSpaceReqType {

    NO_NEED("no_need_of_white_space"),
    NEEDS_SMALL_WS("need_of_small_white_space"),
    NEEDS_BIG_WS("need_of_big_white_space"),
    FORCED_NEED("forces_need_of_white_space");

    private final String msg;

    private WhiteSpaceReqType(String msg) {
        this.msg = msg;
    }

    public String getMsg() {
        return msg;
    }

    @Override
    public String toString() {
        return "WhiteSpaceReqType{" + "msg=" + msg + '}';
    }

}
