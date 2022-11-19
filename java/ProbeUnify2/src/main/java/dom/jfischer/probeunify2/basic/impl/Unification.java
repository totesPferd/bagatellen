package dom.jfischer.probeunify2.basic.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.IExtension;
import dom.jfischer.probeunify2.basic.IExpression;
import dom.jfischer.probeunify2.basic.IUnification;

/**
 *
 * @author jfischer
 * @param <Extension>
 * @param <NonVariableExtension>
 */
public class Unification<
        Extension extends IExtension, NonVariableExtension extends IExtension> implements
        IUnification<IExpression<Extension, NonVariableExtension>> {

    private final IUnification<IBaseExpression<NonVariableExtension>> baseUnification
            = new BaseUnification<>();
    private final IUnification<Extension> extensionUnification;

    public Unification(IUnification<Extension> extensionUnification) {
        this.extensionUnification = extensionUnification;
    }

    @Override
    public boolean unify(IExpression<Extension, NonVariableExtension> arg1, IExpression<Extension, NonVariableExtension> arg2) {
        return this.extensionUnification.unify(arg1.getExtension(), arg2.getExtension())
                && this.baseUnification.unify(arg1.getBaseExpression(), arg2.getBaseExpression());
    }

}
