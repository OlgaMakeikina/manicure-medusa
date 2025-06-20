import type { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"
import { testAuth } from "../../middleware/test-auth"

export const GET = async (
  req: MedusaRequest,
  res: MedusaResponse
) => {
  testAuth(req, res, () => {})
  
  try {
    const masterModuleService = req.scope.resolve("master")
    const customerModuleService = req.scope.resolve("customer")
    
    const { 
      city,
      specialization,
      rating_min,
      subscription_only,
      limit = 10,
      offset = 0 
    } = req.query

    const filters: any = {
      is_active: true
    }
    
    if (specialization) {
      filters.specializations = {
        $contains: [specialization]
      }
    }
    
    if (rating_min) {
      filters.rating = {
        $gte: Number(rating_min)
      }
    }
    
    if (subscription_only === "true") {
      filters.subscription_active = true
    }

    const [masters, count] = await masterModuleService.listAndCountMasters(
      filters,
      {
        take: Number(limit),
        skip: Number(offset)
      }
    )

    const mastersWithDetails = await Promise.all(
      masters.map(async (master) => {
        let customerDetails = null
        if (master.customer_id) {
          try {
            customerDetails = await customerModuleService.retrieveCustomer(master.customer_id)
          } catch (error) {
            console.log(`Customer ${master.customer_id} not found`)
          }
        }
        
        return {
          id: master.id,
          license_number: master.license_number,
          specializations: master.specializations,
          work_address: master.work_address,
          rating: master.rating,
          reviews_count: master.reviews_count,
          subscription_active: master.subscription_active,
          master_name: customerDetails?.first_name && customerDetails?.last_name 
            ? `${customerDetails.first_name} ${customerDetails.last_name}`
            : "Мастер",
          avatar: customerDetails?.avatar_url || null
        }
      })
    )

    res.json({
      masters: mastersWithDetails,
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