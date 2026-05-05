from django.shortcuts import render, redirect
from django.contrib import messages
from .models import (Address,)
from .forms import AddressForm
from payment.services.payment_services import (CheckoutServices)
from cart.services.cart_services import get_user_cart
# Create your views here.
def checkout(request):
    cart_items, cart_total = get_user_cart(request)

    if not cart_items:  # Check if cart is empty
        messages.error(request, 'Cart is empty')
        return redirect('cart')
        
    if request.method == 'POST':
        form = AddressForm(request.POST)
        if form.is_valid():
            terms_accepted = form.cleaned_data.get('terms_accepted')
            if terms_accepted:
                checkout_services = CheckoutServices()
                success, message = checkout_services.handle_payment_method(request,form)
                if success:
                    # If Stripe, redirect to Stripe checkout page (session URL)
                    if form.cleaned_data.get('method') == 'STRIPE':
                        return redirect(message)  # message contains Stripe session URL

                    messages.success(request, message)
                    return redirect('checkout')
                else:
                    messages.error(request, message)
                    return redirect('checkout')
                
    else:
        form = AddressForm()
    context={
        'form':form,
        'button': 'Submit',
        'cart_items': cart_items,
        'cart_total': cart_total,
    }
    return render(request, 'payment/checkout.html', context)

def shop_cancel(request):
    return render(request, 'payment/cancel.html')

def success(request):
    checkout_services = CheckoutServices()
    success, message = checkout_services.stripe_payment_success(request)
    if success:
        messages.success(request, message)
    else:
        messages.error(request, message)
        
    return render(request, 'payment/success.html')

