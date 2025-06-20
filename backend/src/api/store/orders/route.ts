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
    const orderModuleService = req.scope.resolve("order")
    
    const { product_request_ids } = req.body
    const customer_id = req.user?.customer_id
    
    if (!customer_id) {
      return res.status(401).json({
        error: "Master authentication required"
      })
    }
    
    if (!product_request_ids || !Array.isArray(product_request_ids)) {
      return res.status(400).json({
        error: "product_request_ids array is required"
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

    const productRequests = await Promise.all(
      product_request_ids.map(id => 
        productRequestModuleService.retrieveProductRequest(id)
      )
    )

    for (const request of productRequests) {
      if (!request) {
        return res.status(404).json({
          error: "One or more product requests not found"
        })
      }
      
      if (request.master_id !== master.id) {
        return res.status(403).json({
          error: "One or more requests are not assigned to you"
        })
      }
      
      if (request.status !== "accepted") {
        return res.status(400).json({
          error: `Cannot purchase request with status: ${request.status}`
        })
      }
    }

    const orderData = {
      currency_code: "rub",
      customer_id: customer_id,
      items: productRequests.map(request => ({
        product_id: request.product_id,
        quantity: request.quantity,
        unit_price: master.subscription_active ? 800 : 1000
      }))
    }

    const order = await orderModuleService.createOrders(orderData)

    await Promise.all(
      productRequests.map(request =>
        productRequestModuleService.updateProductRequests(request.id, {
          status: "purchased"
        })
      )
    )

    res.status(201).json({
      success: true,
      order: order,
      updated_requests: productRequests.length,
      message: "Order created and requests marked as purchased"
    })
  } catch (error) {
    res.status(500).json({
      error: error.message
    })
  }
}