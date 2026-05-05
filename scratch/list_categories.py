import os
import sys
import django

# Add the current directory to sys.path
sys.path.append(os.getcwd())

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'minishop.settings')
django.setup()

from dashboard.models import Category

for cat in Category.objects.all():
    print(f"ID: {cat.id}, Name: {cat.name}, Parent: {cat.parent}")
