import type { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"
import { testAuth } from "../../middleware/test-auth"

export const GET = async (
  req: MedusaRequest,
  res: MedusaResponse
) => {
  testAuth(req, res, () => {})
  
  try {
    const productModuleService = req.scope.resolve("product")
    
    const { 
      category,
      color_type,
      material_type,
      search,
      limit = 20,
      offset = 0 
    } = req.query

    const filters: any = {}
    
    if (category) {
      filters.categories = { category_id: category }
    }
    
    if (search) {
      filters.title = { $ilike: `%${search}%` }
    }

    const [products, count] = await productModuleService.listAndCountProducts(
      filters,
      {
        take: Number(limit),
        skip: Number(offset),
        relations: ["categories", "variants", "images"]
      }
    )

    const productsWithPricing = products.map(product => ({
      ...product,
      retail_price: product.variants?.[0]?.calculated_price?.amount || null,
      wholesale_price: product.variants?.[0]?.calculated_price?.amount ? 
        Math.round(product.variants[0].calculated_price.amount * 0.8) : null,
      subscription_discount: 20
    }))

    res.json({
      products: productsWithPricing,
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