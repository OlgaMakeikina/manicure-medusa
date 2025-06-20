import type { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"
import { testAuth } from "../../middleware/test-auth"

export const GET = async (
  req: MedusaRequest,
  res: MedusaResponse
) => {
  testAuth(req, res, () => {})
  
  try {
    const productRequestModuleService = req.scope.resolve("product_request")
    const masterModuleService = req.scope.resolve("master")
    const customerModuleService = req.scope.resolve("customer")
    const productModuleService = req.scope.resolve("product")
    
    const { 
      status,
      limit = 20,
      offset = 0 
    } = req.query

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
    
    const filters: any = {
      master_id: master.id
    }
    
    if (status) {
      filters.status = status
    }

    const [requests, count] = await productRequestModuleService.listAndCountProductRequests(
      filters,
      {
        take: Number(limit),
        skip: Number(offset),
        order: { created_at: "DESC" }
      }
    )

    const requestsWithDetails = await Promise.all(
      requests.map(async (request) => {
        const [client, product] = await Promise.all([
          customerModuleService.retrieveCustomer(request.client_id).catch(() => null),
          productModuleService.retrieveProduct(request.product_id).catch(() => null)
        ])
        
        return {
          ...request,
          client_name: client?.first_name && client?.last_name 
            ? `${client.first_name} ${client.last_name}`
            : "Клиент",
          client_phone: client?.phone || null,
          product_title: product?.title || "Товар не найден",
          product_image: product?.images?.[0]?.url || null
        }
      })
    )

    res.json({
      requests: requestsWithDetails,
      count,
      pagination: {
        limit: Number(limit),
        offset: Number(offset),
        has_more: count > Number(offset) + Number(limit)
      }
    })
  } catch (error) {
    res.status(500).json({
      error: error.message
    })
  }
}