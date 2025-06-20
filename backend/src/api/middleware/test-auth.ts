import type { MedusaRequest, MedusaResponse, MedusaNextFunction } from "@medusajs/framework/http"

export const testAuth = (req: MedusaRequest, res: MedusaResponse, next: MedusaNextFunction) => {
  const customer_id = req.headers['x-test-customer-id'] as string || 
                     req.query.test_customer_id as string || 
                     'cus_01JY71FF941KY1BY553ZHFMSCA'
                     
  const master_id = req.headers['x-test-master-id'] as string || 
                   req.query.test_master_id as string

  req.user = {
    customer_id: customer_id,
    master_id: master_id,
    role: master_id ? 'MASTER' : 'CLIENT'
  }

  console.log(`🎭 Test Auth: customer_id=${customer_id}, role=${req.user.role}`)
  next()
}