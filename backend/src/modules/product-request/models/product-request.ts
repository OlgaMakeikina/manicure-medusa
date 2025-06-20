import { model } from "@medusajs/framework/utils"

export const ProductRequest = model.define("productRequest", {
  id: model.id().primaryKey(),
  client_id: model.text(),
  master_id: model.text(),
  product_id: model.text(),
  status: model.enum(["requested", "accepted", "purchased", "used"]).default("requested"),
  quantity: model.number().default(1),
  notes: model.text().nullable()
})
