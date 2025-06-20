import type { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"

export const GET = async (
  req: MedusaRequest,
  res: MedusaResponse
) => {
  try {
    const masterModuleService = req.scope.resolve("master")
    const productRequestModuleService = req.scope.resolve("product_request")

    res.json({
      message: "Modules loaded successfully!",
      modules: {
        master: !!masterModuleService,
        product_request: !!productRequestModuleService,
      },
      master_methods: Object.getOwnPropertyNames(Object.getPrototypeOf(masterModuleService)).filter(m => !m.startsWith('_')),
      product_request_methods: Object.getOwnPropertyNames(Object.getPrototypeOf(productRequestModuleService)).filter(m => !m.startsWith('_')),
    })
  } catch (error) {
    res.status(500).json({
      error: error.message,
    })
  }
}
