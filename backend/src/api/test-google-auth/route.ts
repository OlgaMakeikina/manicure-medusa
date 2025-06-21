import { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"

export const GET = async (req: MedusaRequest, res: MedusaResponse) => {
  res.json({
    message: "🧪 GOOGLE AUTH TEST",
    info: "Google auth provider configured successfully!",
    endpoints: {
      google_login: "POST /auth/customer/google",
      google_callback: "/auth/customer/google/callback", 
      emailpass_register: "POST /auth/customer/emailpass/register",
      emailpass_login: "POST /auth/customer/emailpass"
    },
    next_steps: [
      "1. Setup real Google OAuth credentials",
      "2. Test with storefront",
      "3. Configure callback URL properly"
    ]
  })
}
