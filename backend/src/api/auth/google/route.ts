import { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"

export const POST = async (req: MedusaRequest, res: MedusaResponse) => {
  const { google_token } = req.body

  if (!google_token) {
    return res.status(400).json({
      error: "Google токен обязателен"
    })
  }

  try {
    const authService = req.scope.resolve("auth")
    const result = await authService.loginWithGoogle(google_token)

    if (!result.success) {
      return res.status(401).json({
        error: result.message
      })
    }

    res.json({
      success: true,
      message: result.message,
      access_token: result.tokens?.access_token,
      refresh_token: result.tokens?.refresh_token,
      expires_in: result.tokens?.expires_in,
      user: result.user
    })
  } catch (error) {
    res.status(500).json({
      error: "Ошибка входа через Google"
    })
  }
}
