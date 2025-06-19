import { Suspense } from "react"
import { listRegions } from "@lib/data/regions"
import { StoreRegion } from "@medusajs/types"
import LocalizedClientLink from "@modules/common/components/localized-client-link"
import CartButton from "@modules/layout/components/cart-button"
import SideMenu from "@modules/layout/components/side-menu"
import DesktopMenu from "@modules/layout/components/desktop-menu"

export default async function Nav() {
  const regions = await listRegions().then((regions: StoreRegion[]) => regions)

  return (
    <div className="sticky top-0 inset-x-0 z-50 group">
      <header className="relative h-16 mx-auto border-b duration-200 bg-white border-ui-border-base">
        <nav className="content-container txt-xsmall-plus text-ui-fg-subtle flex items-center justify-between w-full h-full text-small-regular">
          
          <div className="flex-1 basis-0 h-full flex items-center">
            <div className="h-full md:hidden">
              <SideMenu regions={regions} />
            </div>
          </div>

          <div className="flex items-center h-full">
            <LocalizedClientLink
              href="/"
              className="txt-compact-xlarge-plus hover:text-ui-fg-base uppercase"
              data-testid="nav-store-link"
            >
              ManicureStore
            </LocalizedClientLink>
          </div>

          <div className="hidden md:flex items-center gap-x-8 h-full flex-1 basis-0 justify-center ml-8">
            <DesktopMenu />
          </div>

          <div className="flex items-center gap-x-4 h-full flex-1 basis-0 justify-end">
            <LocalizedClientLink
              className="hover:text-ui-fg-base whitespace-nowrap"
              href="/account"
              data-testid="nav-account-link"
            >
              Личный кабинет
            </LocalizedClientLink>
            <Suspense
              fallback={
                <LocalizedClientLink
                  className="hover:text-ui-fg-base flex gap-2"
                  href="/cart"
                  data-testid="nav-cart-link"
                >
                  🛒 (0)
                </LocalizedClientLink>
              }
            >
              <CartButton />
            </Suspense>
          </div>
        </nav>
      </header>
    </div>
  )
}