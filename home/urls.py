from django.urls import path, include
from . import views
from dashboard import views as dashboard_views
urlpatterns = [
    path('', views.home, name='home'),
    path('about/', views.about, name='about'),
    path('contact/', views.contact, name='contact'),
    path('login/', views.login, name='login'),
    path('register/', views.register, name='register'),
    path('logout/', dashboard_views.logout, name='logout'),
    
]