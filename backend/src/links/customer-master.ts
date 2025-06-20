import { defineLink } from "@medusajs/framework/utils"
import MasterModule from "../modules/master"
import CustomerModule from "@medusajs/medusa/customer"

export default defineLink(
  CustomerModule.linkable.customer,
  MasterModule.linkable.master
)
