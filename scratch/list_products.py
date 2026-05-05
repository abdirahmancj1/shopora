import os
import sys
import django

sys.path.append(os.getcwd())
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'minishop.settings')
django.setup()

from dashboard.models import Product

for prod in Product.objects.all():
    print(f"ID: {prod.id}, Name: {prod.name}, Category: {prod.category}")
