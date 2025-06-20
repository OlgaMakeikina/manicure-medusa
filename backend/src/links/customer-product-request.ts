import { defineLink } from "@medusajs/framework/utils"
import ProductRequestModule from "../modules/product-request"
import CustomerModule from "@medusajs/medusa/customer"

export default defineLink(
  {
    linkable: CustomerModule.linkable.customer,
    isList: true,
  },
  ProductRequestModule.linkable.productRequest
)
