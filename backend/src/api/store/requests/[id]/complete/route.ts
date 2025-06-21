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
    const { work_notes } = req.body || {}
    const customer_id = req.user?.customer_id
    
    if (!customer_id) {
      return res.status(401).json({
        error: "Master authentication required"
      })
    }

    // Проверяем что пользователь - мастер
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
    
    if (productRequest.status !== "purchased") {
      return res.status(400).json({
        error: `Cannot complete request with status: ${productRequest.status}. Must be 'purchased' first.`
      })
    }

    // Обновляем статус и добавляем заметки о работе
    const updatedRequest = await productRequestModuleService.updateProductRequests(id, {
      status: "used",
      notes: work_notes ? `${productRequest.notes || ''}\n--- РАБОТА ЗАВЕРШЕНА ---\n${work_notes}` : productRequest.notes
    })

    res.json({
      success: true,
      product_request: updatedRequest,
      message: "Work completed successfully. Status changed to 'used'",
      work_completed_at: new Date().toISOString()
    })
  } catch (error) {
    res.status(500).json({
      error: error.message
    })
  }
}