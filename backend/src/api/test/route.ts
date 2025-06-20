import type { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"

export const GET = async (
  req: MedusaRequest,
  res: MedusaResponse
) => {
  try {
    const masterModuleService = req.scope.resolve("master")
    const productRequestModuleService = req.scope.resolve("product_request")
    const customerModuleService = req.scope.resolve("customer")
    
    console.log("🧪 API Status Check...")
    
    // 1. Проверяем существующих клиентов и мастеров
    const customers = await customerModuleService.listCustomers()
    const masters = await masterModuleService.listMasters()
    const requests = await productRequestModuleService.listProductRequests()
    
    console.log(`✅ Found ${customers.length} customers, ${masters.length} masters, ${requests.length} requests`)

    res.json({
      success: true,
      message: "🎯 API SERVER IS RUNNING!",
      stats: {
        customers_count: customers.length,
        masters_count: masters.length,
        requests_count: requests.length
      },
      test_endpoints: {
        working: [
          `✅ GET ${req.protocol}://${req.get('host')}/test`,
          `🔧 GET ${req.protocol}://${req.get('host')}/store/products`,
          `🔧 GET ${req.protocol}://${req.get('host')}/store/masters`,
          `🔧 POST ${req.protocol}://${req.get('host')}/store/product-requests`
        ]
      },
      sample_data: {
        customer: customers[0] ? {
          id: customers[0].id,
          email: customers[0].email,
          name: `${customers[0].first_name} ${customers[0].last_name}`
        } : null,
        master: masters[0] ? {
          id: masters[0].id,
          license: masters[0].license_number,
          subscription: masters[0].subscription_active
        } : null,
        request: requests[0] ? {
          id: requests[0].id,
          status: requests[0].status,
          notes: requests[0].notes
        } : null
      },
      next_test: "curl http://localhost:9000/store/products"
    })
  } catch (error) {
    console.error("❌ Test failed:", error)
    res.status(500).json({
      error: error.message
    })
  }
}