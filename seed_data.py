import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'minishop.settings')
django.setup()

from dashboard.models import Category, Product

def seed():
    # 1. Create Category
    category, created = Category.objects.get_or_create(name="Electronics", defaults={'slug': 'electronics'})
    if created:
        print("Created Category: Electronics")
    else:
        print("Category Electronics already exists")

    # 2. Create Products
    products_data = [
        {
            "name": "Smartphone X",
            "description": "A high-end smartphone with a stunning display.",
            "price": 999.99,
            "quantity": 10,
            "category": category,
            "image": "product/test_phone.jpg"
        },
        {
            "name": "Laptop Pro",
            "description": "Powerful laptop for professionals and gamers.",
            "price": 1499.99,
            "quantity": 5,
            "category": category,
            "image": "product/test_laptop.jpg"
        }
    ]

    for p_data in products_data:
        product, created = Product.objects.get_or_create(
            name=p_data['name'],
            defaults=p_data
        )
        if created:
            print(f"Created Product: {p_data['name']}")
        else:
            print(f"Product {p_data['name']} already exists")

if __name__ == "__main__":
    seed()
