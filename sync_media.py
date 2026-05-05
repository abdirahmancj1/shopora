import os
import django
from django.core.files import File

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'minishop.settings')
django.setup()

from product.models import Product

def sync_to_cloudinary():
    print("Starting Cloudinary sync...")
    products = Product.objects.all()
    
    for product in products:
        if product.image:
            try:
                # Check if the image needs re-uploading
                # If you just switched to Cloudinary, saving again will trigger the upload
                name = product.image.name
                print(f"Syncing {product.name} ({name})...")
                
                # We simply re-save the instance to trigger the CloudinaryStorage upload
                # This assumes the files exist in your local media folder still
                product.save()
                print(f"Successfully synced {product.name}")
            except Exception as e:
                print(f"Error syncing {product.name}: {e}")

if __name__ == "__main__":
    sync_to_cloudinary()
