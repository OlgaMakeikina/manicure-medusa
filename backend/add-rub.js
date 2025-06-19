const fetch = require('node-fetch')

async function addRubSupport() {
  try {
    // Получаем токен админа (нужно войти в админку и получить)
    const response = await fetch('http://localhost:9000/admin/stores', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer YOUR_ADMIN_TOKEN'
      },
      body: JSON.stringify({
        supported_currencies: ['rub', 'eur']
      })
    })
    
    console.log('Store updated with RUB support')
  } catch (error) {
    console.error('Error:', error)
  }
}

addRubSupport()