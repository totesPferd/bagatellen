package dom.jfischer.probeunify2.basic;

/**
 *
 * @author jfischer
 * @param <Extension>
 * @param <NonVariableExtension>
 */
public interface IExpression<
        Extension extends IExtension, NonVariableExtension extends IExtension> extends
        IExtension {

    Extension getExtension();

    IBaseExpression<NonVariableExtension> getBaseExpression();

    default boolean eq(IExpression<Extension, NonVariableExtension> other) {
        return this.getBaseExpression().eq(other.getBaseExpression());
    }

}
