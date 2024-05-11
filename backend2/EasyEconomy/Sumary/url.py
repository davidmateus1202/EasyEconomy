from django.urls import path
from . import views



urlpatterns = [ 

    path('total_saldo/', views.TotalSaldo),
    path('total/', views.TotalIngresosUser)


]