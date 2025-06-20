import { Module, MedusaService } from "@medusajs/framework/utils"
import { ProductRequest } from "./models/product-request"

export const PRODUCT_REQUEST_MODULE = "product_request"

class ProductRequestModuleService extends MedusaService({
  ProductRequest,
}) {}

export default Module(PRODUCT_REQUEST_MODULE, {
  service: ProductRequestModuleService,
})
