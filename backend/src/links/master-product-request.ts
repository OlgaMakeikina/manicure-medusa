import { defineLink } from "@medusajs/framework/utils"
import MasterModule from "../modules/master"
import ProductRequestModule from "../modules/product-request"

export default defineLink(
  {
    linkable: MasterModule.linkable.master,
    isList: true,
  },
  ProductRequestModule.linkable.productRequest
)
