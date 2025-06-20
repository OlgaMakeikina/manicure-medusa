import { Module, MedusaService } from "@medusajs/framework/utils"
import { Master } from "./models/master"

export const MASTER_MODULE = "master"

class MasterModuleService extends MedusaService({
  Master,
}) {}

export default Module(MASTER_MODULE, {
  service: MasterModuleService,
})
