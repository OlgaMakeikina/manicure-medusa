"use client"

import { Text } from "@medusajs/ui"
import { getProductPrice } from "@lib/util/get-product-price"
import { HttpTypes } from "@medusajs/types"
import LocalizedClientLink from "@modules/common/components/localized-client-link"
import Thumbnail from "../thumbnail"
import PreviewPrice from "./price"
import React from "react"

export default function ProductPreview({
  product,
  isFeatured,
  region,
}: {
  product: HttpTypes.StoreProduct
  isFeatured?: boolean
  region: HttpTypes.StoreRegion
}) {
  const { cheapestPrice } = getProductPrice({
    product,
  })

  return (
    <div className="relative w-[120px] h-[120px] group cursor-pointer" data-testid="product-wrapper">
        <LocalizedClientLink href={`/products/${product.handle}`} className="block w-full h-full">
          <div className="w-full h-full relative overflow-hidden rounded-lg bg-ui-bg-subtle">
            <Thumbnail
              thumbnail={product.thumbnail}
              images={product.images}
              size="square"
              className="w-full h-full p-0"
            />
          </div>
        </LocalizedClientLink>
        
        <div className="absolute inset-0 bg-black bg-opacity-0 group-hover:bg-opacity-40 transition-all duration-200 rounded-lg flex flex-col justify-between p-3 opacity-0 group-hover:opacity-100">
          <div className="flex justify-end space-x-2">
            <button 
              className="w-8 h-8 bg-white rounded-full flex items-center justify-center shadow-lg hover:bg-gray-100 transition-colors"
              onClick={(e) => {
                e.preventDefault()
                e.stopPropagation()
              }}
              title="Добавить в корзину"
            >
              <svg className="w-4 h-4 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 3h2l.4 2M7 13h10l4-8H5.4m0 0L7 13m0 0l-2.5 5L17 18" />
              </svg>
            </button>
            <button 
              className="w-8 h-8 bg-white rounded-full flex items-center justify-center shadow-lg hover:bg-gray-100 transition-colors"
              onClick={(e) => {
                e.preventDefault()
                e.stopPropagation()
              }}
              title="Поделиться"
            >
              <svg className="w-4 h-4 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.367 2.684 3 3 0 00-5.367-2.684z" />
              </svg>
            </button>
          </div>
          
          <div className="text-white">
            <Text className="text-sm font-medium mb-1 leading-tight" data-testid="product-title" style={{
              display: '-webkit-box',
              WebkitLineClamp: 2,
              WebkitBoxOrient: 'vertical',
              overflow: 'hidden'
            }}>
              {product.title}
            </Text>
            {cheapestPrice && (
              <div className="text-xs font-semibold">
                <PreviewPrice price={cheapestPrice} />
              </div>
            )}
          </div>
      </div>
    </div>
  )
}