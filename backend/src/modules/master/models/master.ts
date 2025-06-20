import { model } from "@medusajs/framework/utils"

export const Master = model.define("master", {
  id: model.id().primaryKey(),
  customer_id: model.text(),
  license_number: model.text().nullable(),
  subscription_active: model.boolean().default(false),
  certification_date: model.dateTime().nullable(),
  franchisee_id: model.text().nullable(),
  specializations: model.json().nullable(),
  work_address: model.text().nullable(),
  rating: model.number().nullable(),
  reviews_count: model.number().default(0),
  is_active: model.boolean().default(true)
})
