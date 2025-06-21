@echo off
echo.
echo ================================
echo ДЕТАЛЬНАЯ ОТЛАДКА AUTH МОДУЛЯ
echo ================================
echo.

echo Тест 1: Debug регистрация с подробным логированием
curl -X POST ^
  -H "x-publishable-api-key: pk_8222f0fc611907b2d6ae8e29a9bd5de3b5170c42e639845f0a7178e3d8fc9684" ^
  -H "Content-Type: application/json" ^
  -d "{\"email\":\"debug@test.com\",\"password\":\"123456\",\"first_name\":\"Debug User\"}" ^
  http://localhost:9000/auth/debug-register

echo.
echo.
echo ================================
echo ДЕТАЛЬНОЕ ЛОГИРОВАНИЕ ЗАВЕРШЕНО
echo ================================
pause
