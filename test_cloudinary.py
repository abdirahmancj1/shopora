import os
import django
from django.core.files.base import ContentFile
from django.core.files.storage import default_storage

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'minishop.settings')
django.setup()

def test_cloudinary_upload():
    print("Testing Cloudinary Connection...")
    try:
        # Create a tiny 1x1 transparent pixel as a test image
        test_file = ContentFile(b'\x47\x49\x46\x38\x39\x61\x01\x00\x01\x00\x80\x00\x00\xff\xff\xff\x00\x00\x00\x21\xf9\x04\x01\x00\x00\x00\x00\x2c\x00\x00\x00\x00\x01\x00\x01\x00\x00\x02\x02\x44\x01\x00\x3b', name='test_cloudinary_connection.gif')
        
        # Attempt to save it using the default storage (Cloudinary)
        path = default_storage.save('test_uploads/test_pixel.gif', test_file)
        url = default_storage.url(path)
        
        print("\n[SUCCESS!]")
        print(f"Cloudinary URL: {url}")
        print("\nIf you can see the URL above, your configuration is PERFECT.")
        
        # Clean up: delete the test file from Cloudinary
        default_storage.delete(path)
        print("Cleaned up test file.")
        
    except Exception as e:
        print("\n[FAILED]")
        print(f"Error: {e}")
        print("\nCheck your CLOUD_NAME, API_KEY, and API_SECRET in settings.py")

if __name__ == "__main__":
    test_cloudinary_upload()
