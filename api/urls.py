from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import (
    ProductViewSet, CategoryViewSet, CartViewSet, 
    OrderViewSet, UserViewSet, SearchAPIView, CheckoutAPIView
)

router = DefaultRouter()
router.register(r'products', ProductViewSet, basename='product')
router.register(r'categories', CategoryViewSet, basename='category')
router.register(r'cart', CartViewSet, basename='cart')
router.register(r'orders', OrderViewSet, basename='order')
router.register(r'users', UserViewSet, basename='user')

urlpatterns = [
    path('', include(router.urls)),
    path('search/', SearchAPIView.as_view(), name='api-search'),
    path('checkout/', CheckoutAPIView.as_view(), name='api-checkout'),
]
