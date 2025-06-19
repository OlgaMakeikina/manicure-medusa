"use client"

import { Popover, PopoverButton, PopoverPanel, Transition } from "@headlessui/react"
import { ChevronDownMini } from "@medusajs/icons"
import { Fragment } from "react"
import LocalizedClientLink from "@modules/common/components/localized-client-link"

const catalogItems = [
  {
    name: "Лаки",
    href: "/catalog/lacquers"
  },
  {
    name: "Прочие товары",
    href: "/catalog/supplies"
  }
]

const DesktopMenu = () => {
  return (
    <div className="flex items-center gap-x-8 h-full">
      <LocalizedClientLink
        href="/"
        className="hover:text-ui-fg-base transition-colors"
      >
        Главная
      </LocalizedClientLink>

      <Popover className="relative h-full flex items-center">
        {({ open }) => (
          <>
            <PopoverButton className="flex items-center gap-1 hover:text-ui-fg-base transition-colors outline-none">
              Каталог
              <ChevronDownMini 
                className={`transition-transform duration-200 ${open ? 'rotate-180' : ''}`}
              />
            </PopoverButton>

            <Transition
              as={Fragment}
              enter="transition ease-out duration-200"
              enterFrom="opacity-0 translate-y-1"
              enterTo="opacity-100 translate-y-0"
              leave="transition ease-in duration-150"
              leaveFrom="opacity-100 translate-y-0"
              leaveTo="opacity-0 translate-y-1"
            >
              <PopoverPanel className="absolute left-0 z-10 mt-0 w-48 top-full">
                <div className="overflow-hidden rounded-lg shadow-lg ring-1 ring-black ring-opacity-5 bg-white">
                  <div className="py-2">
                    {catalogItems.map((item) => (
                      <LocalizedClientLink
                        key={item.name}
                        href={item.href}
                        className="block px-4 py-3 text-sm text-gray-700 hover:bg-gray-100 transition-colors"
                      >
                        {item.name}
                      </LocalizedClientLink>
                    ))}
                  </div>
                </div>
              </PopoverPanel>
            </Transition>
          </>
        )}
      </Popover>

      <LocalizedClientLink
        href="/delivery"
        className="hover:text-ui-fg-base transition-colors"
      >
        Доставка и оплата
      </LocalizedClientLink>

      <LocalizedClientLink
        href="/contacts"
        className="hover:text-ui-fg-base transition-colors"
      >
        Контакты
      </LocalizedClientLink>
    </div>
  )
}

export default DesktopMenu