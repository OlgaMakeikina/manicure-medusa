import type { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"
import { testAuth } from "../../middleware/test-auth"

export const POST = async (
  req: MedusaRequest,
  res: MedusaResponse
) => {
  testAuth(req, res, () => {})
  
  try {
    const productRequestModuleService = req.scope.resolve("product_request")
    const masterModuleService = req.scope.resolve("master")
    const productModuleService = req.scope.resolve("product")
    
    const { 
      master_id, 
      product_id, 
      quantity = 1, 
      notes 
    } = req.body

    if (!master_id || !product_id) {
      return res.status(400).json({
        error: "master_id and product_id are required"
      })
    }

    const customer_id = req.user?.customer_id
    if (!customer_id) {
      return res.status(401).json({
        error: "Customer authentication required"
      })
    }

    const [master, product] = await Promise.all([
      masterModuleService.retrieveMaster(master_id),
      productModuleService.retrieveProduct(product_id)
    ])

    if (!master) {
      return res.status(404).json({ error: "Master not found" })
    }
    
    if (!product) {
      return res.status(404).json({ error: "Product not found" })
    }

    const productRequest = await productRequestModuleService.createProductRequests({
      client_id: customer_id,
      master_id,
      product_id,
      status: "requested",
      quantity: Number(quantity),
      notes: notes || ""
    })

    res.status(201).json({
      success: true,
      product_request: productRequest,
      message: "Request sent to master successfully"
    })
  } catch (error) {
    res.status(500).json({
      error: error.message
    })
  }
}