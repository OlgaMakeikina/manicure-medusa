import type { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"
import { testAuth } from "../../../middleware/test-auth"

export const GET = async (
  req: MedusaRequest,
  res: MedusaResponse
) => {
  testAuth(req, res, () => {})
  
  try {
    const masterModuleService = req.scope.resolve("master")
    const customerModuleService = req.scope.resolve("customer")
    const productRequestModuleService = req.scope.resolve("product_request")
    
    const { id } = req.params

    const master = await masterModuleService.retrieveMaster(id)
    
    if (!master) {
      return res.status(404).json({
        error: "Master not found"
      })
    }

    if (!master.is_active) {
      return res.status(404).json({
        error: "Master is not currently accepting orders"
      })
    }

    // Получаем данные клиента-мастера
    let customerDetails = null
    if (master.customer_id) {
      try {
        customerDetails = await customerModuleService.retrieveCustomer(master.customer_id)
      } catch (error) {
        console.log(`Customer ${master.customer_id} not found`)
      }
    }

    // Статистика работ мастера
    const completedWorks = await productRequestModuleService.listProductRequests({
      master_id: master.id,
      status: "used"
    })

    const activeRequests = await productRequestModuleService.listProductRequests({
      master_id: master.id,
      status: ["requested", "accepted", "purchased"]
    })

    // Последние отзывы (заглушка, пока нет модели отзывов)
    const recentReviews = [
      {
        id: "rev_1",
        client_name: "Анна К.",
        rating: 5,
        comment: "Отличная работа! Очень аккуратно и красиво",
        created_at: "2025-06-15T10:00:00Z"
      },
      {
        id: "rev_2", 
        client_name: "Мария С.",
        rating: 5,
        comment: "Профессионал своего дела, рекомендую!",
        created_at: "2025-06-10T14:30:00Z"
      }
    ]

    const masterProfile = {
      id: master.id,
      license_number: master.license_number,
      specializations: master.specializations || [],
      work_address: master.work_address,
      rating: master.rating || 4.8,
      reviews_count: master.reviews_count || recentReviews.length,
      subscription_active: master.subscription_active,
      certification_date: master.certification_date,
      is_active: master.is_active,
      
      // Данные мастера как клиента
      master_name: customerDetails?.first_name && customerDetails?.last_name 
        ? `${customerDetails.first_name} ${customerDetails.last_name}`
        : "Мастер маникюра",
      avatar: customerDetails?.avatar_url || null,
      phone: customerDetails?.phone || null,
      
      // Статистика
      stats: {
        completed_works: completedWorks.length,
        active_requests: activeRequests.length,
        experience_years: master.certification_date 
          ? Math.floor((new Date().getTime() - new Date(master.certification_date).getTime()) / (365 * 24 * 60 * 60 * 1000))
          : 1,
        response_time: "~30 мин", // заглушка
        success_rate: "98%" // заглушка
      },

      // Последние отзывы
      recent_reviews: recentReviews.slice(0, 3),

      // Рабочие часы (заглушка)
      working_hours: {
        monday: "9:00-18:00",
        tuesday: "9:00-18:00", 
        wednesday: "9:00-18:00",
        thursday: "9:00-18:00",
        friday: "9:00-18:00",
        saturday: "10:00-16:00",
        sunday: "Выходной"
      },

      // Контакты
      contacts: {
        phone: customerDetails?.phone || null,
        telegram: null, // заглушка
        whatsapp: customerDetails?.phone || null
      }
    }

    res.json({
      master: masterProfile,
      can_book: true,
      booking_info: "Отправьте запрос с выбранными материалами, и мастер свяжется с вами для согласования времени"
    })
  } catch (error) {
    res.status(500).json({
      error: error.message
    })
  }
}