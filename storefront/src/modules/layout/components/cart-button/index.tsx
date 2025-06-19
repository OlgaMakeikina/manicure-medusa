import LocalizedClientLink from "@modules/common/components/localized-client-link"
import { retrieveCart } from "@lib/data/cart"

const CartButton = async () => {
  const cart = await retrieveCart()
  
  const totalItems = cart?.items?.reduce((acc, item) => acc + (item.quantity || 0), 0) || 0

  return (
    <LocalizedClientLink
      className="hover:text-ui-fg-base flex items-center gap-2"
      href="/cart"
      data-testid="nav-cart-link"
    >
      <span className="text-lg">🛒</span>
      <span className="hidden sm:inline">Корзина</span>
      {totalItems > 0 && (
        <span className="bg-ui-bg-interactive text-ui-fg-on-color rounded-full px-2 py-1 text-xs font-medium min-w-[1.25rem] text-center">
          {totalItems}
        </span>
      )}
    </LocalizedClientLink>
  )
}

export default CartButton;