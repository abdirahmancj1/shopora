from rest_framework import serializers
from django.contrib.auth.models import User
from dashboard.models import Product, Category
from cart.models import CartItem
from payment.models import Order, OrderItem, Address

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name', 'password']
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        user = User.objects.create_user(**validated_data)
        return user

class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = '__all__'

class ProductSerializer(serializers.ModelSerializer):
    category_name = serializers.ReadOnlyField(source='category.name')
    image = serializers.ImageField(required=False, allow_null=True)
    quantity = serializers.IntegerField(required=False, default=10)
    category = serializers.PrimaryKeyRelatedField(queryset=Category.objects.all(), required=False, allow_null=True)
    
    class Meta:
        model = Product
        fields = [
            'id', 'name', 'slug', 'description', 'price', 
            'image', 'quantity', 'category', 'category_name', 
            'created_at', 'updated_at'
        ]

class CartItemSerializer(serializers.ModelSerializer):
    product_details = ProductSerializer(source='product', read_only=True)
    
    class Meta:
        model = CartItem
        fields = ['id', 'user', 'product', 'product_name', 'product_price', 'quantity', 'added_at', 'product_details']
        read_only_fields = ['user']

class OrderItemSerializer(serializers.ModelSerializer):
    product_name = serializers.ReadOnlyField(source='product.name')
    
    class Meta:
        model = OrderItem
        fields = ['id', 'product', 'product_name', 'quantity', 'price', 'total']

class AddressSerializer(serializers.ModelSerializer):
    class Meta:
        model = Address
        fields = '__all__'

class OrderSerializer(serializers.ModelSerializer):
    items = OrderItemSerializer(many=True, read_only=True)
    address_details = AddressSerializer(source='address', read_only=True)
    
    class Meta:
        model = Order
        fields = [
            'id', 'order_uuid', 'order_number', 'user', 'address', 
            'address_details', 'status', 'total_price', 'items', 
            'created_at', 'updated_at'
        ]
