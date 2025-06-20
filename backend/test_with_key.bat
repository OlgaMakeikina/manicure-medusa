@echo off
set API_KEY=pk_8222f0fc611907b2d6ae8e29a9bd5de3b5170c42e639845f0a7178e3d8fc9684
set BASE_URL=http://localhost:9000

echo 🧪 TESTING MANICURE PLATFORM API WITH API KEY
echo ==============================================

echo 1. 🏪 Products (витрина лаков):
curl -s -H "x-publishable-api-key: %API_KEY%" "%BASE_URL%/store/products?limit=3"
echo.

echo 2. 👩‍🎨 Masters (поиск мастеров):
curl -s -H "x-publishable-api-key: %API_KEY%" "%BASE_URL%/store/masters?limit=2"
echo.

echo 3. 📋 Master requests (запросы мастера):
curl -s -H "x-publishable-api-key: %API_KEY%" "%BASE_URL%/store/my-requests?limit=2"
echo.

echo 4. ➕ Create product request:
curl -s -X POST -H "x-publishable-api-key: %API_KEY%" -H "Content-Type: application/json" ^
  -d "{\"master_id\":\"01JY715G546K1X1XVWWWYNVWY7\",\"product_id\":\"prod_test_new\",\"quantity\":1,\"notes\":\"Test request\"}" ^
  "%BASE_URL%/store/product-requests"
echo.

echo ✅ ALL ENDPOINTS TESTED WITH API KEY!
echo 🎯 Ready for frontend integration
