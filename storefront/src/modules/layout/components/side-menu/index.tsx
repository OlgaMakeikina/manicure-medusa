"use client"

import { Popover, PopoverPanel, Transition } from "@headlessui/react"
import { ArrowRightMini, XMark, ChevronDownMini } from "@medusajs/icons"
import { Text, clx, useToggleState } from "@medusajs/ui"
import { Fragment, useState } from "react"

import LocalizedClientLink from "@modules/common/components/localized-client-link"
import CountrySelect from "../country-select"
import { HttpTypes } from "@medusajs/types"

const SideMenuItems = {
  "Главная": "/",
  "Каталог": {
    "Лаки": "/catalog/lacquers",
    "Прочие товары": "/catalog/supplies"
  },
  "Доставка и оплата": "/delivery",
  "Контакты": "/contacts",
  "Личный кабинет": "/account"
}

const SideMenu = ({ regions }: { regions: HttpTypes.StoreRegion[] | null }) => {
  const toggleState = useToggleState()
  const [openSubmenu, setOpenSubmenu] = useState<string | null>(null)

  const toggleSubmenu = (key: string) => {
    setOpenSubmenu(openSubmenu === key ? null : key)
  }

  return (
    <div className="h-full">
      <div className="flex items-center h-full">
        <Popover className="h-full flex">
          {({ open, close }) => (
            <>
              <div className="relative flex h-full">
                <Popover.Button
                  data-testid="nav-menu-button"
                  className="relative h-full flex items-center transition-all ease-out duration-200 focus:outline-none hover:text-ui-fg-base"
                >
                  Меню
                </Popover.Button>
              </div>

              <Transition
                show={open}
                as={Fragment}
                enter="transition ease-out duration-150"
                enterFrom="opacity-0"
                enterTo="opacity-100 backdrop-blur-2xl"
                leave="transition ease-in duration-150"
                leaveFrom="opacity-100 backdrop-blur-2xl"
                leaveTo="opacity-0"
              >
                <PopoverPanel className="flex flex-col absolute w-full pr-4 sm:pr-0 sm:w-1/3 2xl:w-1/4 sm:min-w-min h-[calc(100vh-1rem)] z-30 inset-x-0 text-sm text-ui-fg-on-color m-2 backdrop-blur-2xl">
                  <div
                    data-testid="nav-menu-popup"
                    className="flex flex-col h-full bg-[rgba(3,7,18,0.5)] rounded-rounded justify-between p-6"
                  >
                    <div className="flex justify-end" id="xmark">
                      <button data-testid="close-menu-button" onClick={close}>
                        <XMark />
                      </button>
                    </div>
                    <ul className="flex flex-col gap-4 items-start justify-start">
                      {Object.entries(SideMenuItems).map(([name, href]) => {
                        const isSubmenu = typeof href === 'object'
                        
                        if (isSubmenu) {
                          return (
                            <li key={name} className="w-full">
                              <button
                                className="flex items-center justify-between w-full text-left text-2xl leading-8 hover:text-ui-fg-disabled"
                                onClick={() => toggleSubmenu(name)}
                              >
                                {name}
                                <ChevronDownMini 
                                  className={`transition-transform duration-200 ${
                                    openSubmenu === name ? 'rotate-180' : ''
                                  }`}
                                />
                              </button>
                              <Transition
                                show={openSubmenu === name}
                                enter="transition-all duration-200 ease-out"
                                enterFrom="opacity-0 max-h-0"
                                enterTo="opacity-100 max-h-96"
                                leave="transition-all duration-200 ease-in"
                                leaveFrom="opacity-100 max-h-96"
                                leaveTo="opacity-0 max-h-0"
                              >
                                <ul className="ml-4 mt-2 space-y-2 overflow-hidden">
                                  {Object.entries(href).map(([subName, subHref]) => (
                                    <li key={subName}>
                                      <LocalizedClientLink
                                        href={subHref}
                                        className="text-lg leading-6 hover:text-ui-fg-disabled block"
                                        onClick={close}
                                      >
                                        {subName}
                                      </LocalizedClientLink>
                                    </li>
                                  ))}
                                </ul>
                              </Transition>
                            </li>
                          )
                        }

                        return (
                          <li key={name}>
                            <LocalizedClientLink
                              href={href}
                              className="text-2xl leading-8 hover:text-ui-fg-disabled"
                              onClick={close}
                              data-testid={`${name.toLowerCase()}-link`}
                            >
                              {name}
                            </LocalizedClientLink>
                          </li>
                        )
                      })}
                    </ul>
                    <div className="flex flex-col gap-y-6">
                      <div
                        className="flex justify-between"
                        onMouseEnter={toggleState.open}
                        onMouseLeave={toggleState.close}
                      >
                        {regions && (
                          <CountrySelect
                            toggleState={toggleState}
                            regions={regions}
                          />
                        )}
                        <ArrowRightMini
                          className={clx(
                            "transition-transform duration-150",
                            toggleState.state ? "-rotate-90" : ""
                          )}
                        />
                      </div>
                      <Text className="flex justify-between txt-compact-small">
                        © {new Date().getFullYear()} ManicureStore. Все права защищены.
                      </Text>
                    </div>
                  </div>
                </PopoverPanel>
              </Transition>
            </>
          )}
        </Popover>
      </div>
    </div>
  )
}

export default SideMenu