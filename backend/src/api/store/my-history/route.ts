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
    const productModuleService = req.scope.resolve("product")
    
    const { 
      status,
      limit = 20,
      offset = 0 
    } = req.query

    const customer_id = req.user?.customer_id
    if (!customer_id) {
      return res.status(401).json({
        error: "Client authentication required"
      })
    }

    const filters: any = {
      client_id: customer_id
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
        const [master, product] = await Promise.all([
          masterModuleService.retrieveMaster(request.master_id).catch(() => null),
          productModuleService.retrieveProduct(request.product_id).catch(() => null)
        ])
        
        return {
          id: request.id,
          status: request.status,
          quantity: request.quantity,
          notes: request.notes,
          created_at: request.created_at,
          updated_at: request.updated_at,
          master: master ? {
            id: master.id,
            license_number: master.license_number,
            work_address: master.work_address,
            rating: master.rating,
            specializations: master.specializations
          } : null,
          product: product ? {
            id: product.id,
            title: product.title,
            thumbnail: product.thumbnail,
            price: product.variants?.[0]?.calculated_price?.amount || null
          } : null
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
      },
      stats: {
        total: count,
        by_status: {
          requested: requestsWithDetails.filter(r => r.status === 'requested').length,
          accepted: requestsWithDetails.filter(r => r.status === 'accepted').length,
          purchased: requestsWithDetails.filter(r => r.status === 'purchased').length,
          used: requestsWithDetails.filter(r => r.status === 'used').length
        }
      }
    })
  } catch (error) {
    res.status(500).json({
      error: error.message
    })
  }
}