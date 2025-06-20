import { defineLink } from "@medusajs/framework/utils"
import ProductRequestModule from "../modules/product-request"
import ProductModule from "@medusajs/medusa/product"

export default defineLink(
  ProductRequestModule.linkable.productRequest,
  ProductModule.linkable.product
)
