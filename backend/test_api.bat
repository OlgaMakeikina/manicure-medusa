@echo off
echo 🧪 TESTING MANICURE PLATFORM API ENDPOINTS
echo ==========================================

set BASE_URL=http://localhost:9000

echo 📋 Testing basic endpoints:
echo 1. Test endpoint (should work if server is running)
curl -s %BASE_URL%/test
echo.

echo 2. Store products endpoint
curl -s "%BASE_URL%/store/products?limit=5"
echo.

echo 3. Store masters endpoint  
curl -s "%BASE_URL%/store/masters?limit=3"
echo.

echo 4. Creating product request (POST)
curl -X POST %BASE_URL%/store/product-requests ^
  -H "Content-Type: application/json" ^
  -d "{\"master_id\": \"test_master_id\", \"product_id\": \"prod_test_123\", \"client_id\": \"test_client_id\", \"quantity\": 2, \"notes\": \"Красный лак для тестирования\"}"

echo.
echo 🎯 API ENDPOINTS OVERVIEW:
echo GET  /store/products      - витрина лаков
echo POST /store/product-requests - отправить лак мастеру
echo GET  /store/masters       - поиск мастеров
echo GET  /store/my-requests   - входящие запросы мастера
echo PUT  /store/requests/:id/accept - принять запрос
echo POST /store/orders        - выкупить товары
echo.
echo ⚠️  NOTE: Server must be running on localhost:9000
echo 🚀 Start server: npm run dev (or node node_modules/@medusajs/cli/cli.js develop)
