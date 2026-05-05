from django.shortcuts import render
from django.contrib.auth.forms import UserCreationForm, AuthenticationForm
from .forms import (SignUpForm, loginForm)
from django.contrib.auth import authenticate, login as auth_login, logout as auth_logout
from django.shortcuts import redirect
from django.contrib.auth.models import User
from django.contrib import messages
from django.db import transaction
from dashboard.models import Product

def home(request):
    products = Product.objects.all().order_by('-created_at')[:8]
    return render(request, 'home/index.html', {'products': products})

def about(request):
    return render(request, 'home/pages/about/about.html')

def contact(request):
    return render(request, 'home/pages/contact/contact.html')

def login(request):
    if request.method == 'POST':
        form = loginForm(request.POST)
        if form.is_valid():
            username = form.cleaned_data.get('username')
            password = form.cleaned_data.get('password')
            user = authenticate(username=username, password=password)
            if user is not None:
                auth_login(request, user)
                messages.success(request, 'Welcome Back')
                return redirect('vendor_dashboard')
            else:
                # Re-render the form with an error — don't redirect (loses the message)
                form.add_error(None, 'Invalid username or password.')
    else:
        form = loginForm()
    return render(request, 'home/pages/auth/login.html', {'form': form})

def register(request):
    if request.method == 'POST':
        form = SignUpForm(request.POST)
        if form.is_valid():
            with transaction.atomic():
                form.save()
                username = form.cleaned_data.get('username')
                password = form.cleaned_data.get('password1')
                user = authenticate(username=username, password=password)
                auth_login(request, user)
                messages.success(request, 'Account created! Welcome.')
                return redirect('vendor_dashboard')
        # Re-render the form with all Django validation errors visible to the user
        # (don't redirect — redirect discards form field errors)
    else:
        form = SignUpForm()
    return render(request, 'home/pages/auth/register.html', {'form': form})