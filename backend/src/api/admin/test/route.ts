import type { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"

export const GET = async (
  req: MedusaRequest,
  res: MedusaResponse
) => {
  try {
    const masterModuleService = req.scope.resolve("master")
    const productRequestModuleService = req.scope.resolve("product_request")

    res.json({
      message: "Modules test",
      modules: {
        master: !!masterModuleService,
        product_request: !!productRequestModuleService,
      },
      master_methods: Object.getOwnPropertyNames(Object.getPrototypeOf(masterModuleService)),
      product_request_methods: Object.getOwnPropertyNames(Object.getPrototypeOf(productRequestModuleService)),
    })
  } catch (error) {
    res.status(500).json({
      error: error.message,
    })
  }
}
