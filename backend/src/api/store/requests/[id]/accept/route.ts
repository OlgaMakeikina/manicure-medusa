import type { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"
import { testAuth } from "../../../../middleware/test-auth"

export const PUT = async (
  req: MedusaRequest,
  res: MedusaResponse
) => {
  testAuth(req, res, () => {})
  
  try {
    const productRequestModuleService = req.scope.resolve("product_request")
    const masterModuleService = req.scope.resolve("master")
    
    const { id } = req.params
    const customer_id = req.user?.customer_id
    
    if (!customer_id) {
      return res.status(401).json({
        error: "Master authentication required"
      })
    }

    const masters = await masterModuleService.listMasters({
      customer_id: customer_id
    })
    
    if (!masters.length) {
      return res.status(403).json({
        error: "Master profile not found"
      })
    }
    
    const master = masters[0]

    const productRequest = await productRequestModuleService.retrieveProductRequest(id)
    
    if (!productRequest) {
      return res.status(404).json({
        error: "Product request not found"
      })
    }
    
    if (productRequest.master_id !== master.id) {
      return res.status(403).json({
        error: "This request is not assigned to you"
      })
    }
    
    if (productRequest.status !== "requested") {
      return res.status(400).json({
        error: `Cannot accept request with status: ${productRequest.status}`
      })
    }

    const updatedRequest = await productRequestModuleService.updateProductRequests(id, {
      status: "accepted"
    })

    res.json({
      success: true,
      product_request: updatedRequest,
      message: "Request accepted successfully"
    })
  } catch (error) {
    res.status(500).json({
      error: error.message
    })
  }
}