from rest_framework import viewsets, permissions, status, filters
from rest_framework.response import Response
from rest_framework.views import APIView
from django.contrib.auth.models import User
from dashboard.models import Product, Category
from cart.models import CartItem
from payment.models import Order, OrderItem
from .serializers import (
    UserSerializer, ProductSerializer, CategorySerializer, 
    CartItemSerializer, OrderSerializer
)

class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    
    def get_permissions(self):
        if self.action == 'create':
            return [permissions.AllowAny()]
        return [permissions.IsAuthenticated()]

class ProductViewSet(viewsets.ModelViewSet):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['name', 'description']
    ordering_fields = ['price', 'created_at']

    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update', 'destroy']:
            return [permissions.IsAdminUser()]
        return [permissions.AllowAny()]

class CategoryViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer

class CartViewSet(viewsets.ModelViewSet):
    serializer_class = CartItemSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return CartItem.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        product = serializer.validated_data['product']
        serializer.save(
            user=self.request.user,
            product_name=product.name,
            product_price=product.price
        )

class OrderViewSet(viewsets.ModelViewSet):
    serializer_class = OrderSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Order.objects.filter(user=self.request.user)

from django.db import transaction
from payment.models import Address, Payment, Order, OrderItem

class CheckoutAPIView(APIView):
    permission_classes = [permissions.AllowAny] # Change to IsAuthenticated if needed

    def post(self, request):
        data = request.data
        try:
            with transaction.atomic():
                # 1. Create Address
                address = Address.objects.create(
                    user=request.user if request.user.is_authenticated else None,
                    first_name=data.get('first_name', 'Mobile'),
                    last_name=data.get('last_name', 'User'),
                    phone=data.get('phone', ''),
                    email=data.get('email', 'mobile@example.com'),
                    address=data.get('address', 'Mobile Checkout'),
                    city=data.get('city', 'Unknown'),
                    country=data.get('country', 'Unknown'),
                    postal_code=data.get('postal_code', '0000'),
                    method='STRIPE' # Defaulting to something for now
                )

                # 2. Create Payment
                payment = Payment.objects.create(
                    amount=data.get('total_price', 0),
                    is_paid=False
                )

                # 3. Create Order
                order = Order.objects.create(
                    user=request.user if request.user.is_authenticated else None,
                    address=address,
                    payment=payment,
                    total_price=data.get('total_price', 0),
                    status='PENDING'
                )

                # 4. Create Order Items
                items = data.get('items', [])
                for item in items:
                    product = Product.objects.get(id=item['id'])
                    OrderItem.objects.create(
                        order=order,
                        product=product,
                        quantity=item['quantity'],
                        price=product.price
                    )

                return Response({
                    "status": "success",
                    "order_number": order.order_number,
                    "order_uuid": str(order.order_uuid)
                }, status=status.HTTP_201_CREATED)

        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)

class SearchAPIView(APIView):
    def get(self, request):
        query = request.query_params.get('q', '')
        products = Product.objects.filter(name__icontains=query)
        serializer = ProductSerializer(products, many=True)
        return Response(serializer.data)
