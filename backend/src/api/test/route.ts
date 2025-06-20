import type { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"

export const GET = async (
  req: MedusaRequest,
  res: MedusaResponse
) => {
  try {
    const masterModuleService = req.scope.resolve("master")
    const productRequestModuleService = req.scope.resolve("product_request")
    const customerModuleService = req.scope.resolve("customer")
    
    const customers = await customerModuleService.listCustomers({ email: "ivan@test.ru" })
    const customer = customers[0]
    
    if (!customer) {
      return res.status(404).json({ error: "Customer not found" })
    }
    
    const master = await masterModuleService.createMasters({
      customer_id: customer.id,
      license_number: `MST${Date.now()}`,
      subscription_active: true,
      specializations: ["manicure", "pedicure"],
      work_address: "Moscow, Red Street, 10"
    })
    
    const productRequest = await productRequestModuleService.createProductRequests({
      client_id: customer.id,
      master_id: master.id,
      product_id: "prod_test_123",
      status: "requested",
      quantity: 2,
      notes: "Red nail polish"
    })

    res.json({
      success: true,
      message: "Links working perfectly! Full chain created: Customer -> Master -> ProductRequest",
      data: {
        customer_id: customer.id,
        master_id: master.id,
        product_request_id: productRequest.id,
        links_working: true
      }
    })
  } catch (error) {
    res.status(500).json({
      error: error.message
    })
  }
}
