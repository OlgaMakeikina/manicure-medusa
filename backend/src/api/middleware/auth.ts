import { NextFunction, Request, Response } from "express"
import { MedusaRequest } from "@medusajs/framework/http"

interface AuthenticatedRequest extends MedusaRequest {
  user?: {
    user_id: string
    role: 'client' | 'master' | 'admin' | 'franchisee'
    email?: string
  }
}

export async function authenticateToken(
  req: AuthenticatedRequest,
  res: Response,
  next: NextFunction
) {
  const authHeader = req.headers.authorization
  const token = authHeader && authHeader.split(' ')[1]

  if (!token) {
    return res.status(401).json({
      error: "Токен доступа отсутствует"
    })
  }

  try {
    const authService = req.scope.resolve("auth")
    const user = await authService.verifyAccessToken(token)

    if (!user) {
      return res.status(401).json({
        error: "Недействительный токен"
      })
    }

    req.user = user
    next()
  } catch (error) {
    return res.status(401).json({
      error: "Ошибка проверки токена"
    })
  }
}

export function requireRole(allowedRoles: string[]) {
  return (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
    if (!req.user) {
      return res.status(401).json({
        error: "Пользователь не аутентифицирован"
      })
    }

    if (!allowedRoles.includes(req.user.role)) {
      return res.status(403).json({
        error: "Недостаточно прав доступа"
      })
    }

    next()
  }
}

export const requireClient = requireRole(['client'])
export const requireMaster = requireRole(['master'])
export const requireAdmin = requireRole(['admin'])
export const requireMasterOrAdmin = requireRole(['master', 'admin'])
export const requireAnyRole = requireRole(['client', 'master', 'admin', 'franchisee'])
