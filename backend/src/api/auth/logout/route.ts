import { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"

export const POST = async (req: MedusaRequest, res: MedusaResponse) => {
  const { refresh_token } = req.body

  if (!refresh_token) {
    return res.status(400).json({
      error: "Refresh токен обязателен"
    })
  }

  try {
    const authService = req.scope.resolve("auth")
    const result = await authService.logout(refresh_token)

    res.json({
      success: result.success,
      message: result.message
    })
  } catch (error) {
    res.status(500).json({
      error: "Ошибка при выходе"
    })
  }
}
