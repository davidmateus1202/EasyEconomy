
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('user/', include('user_app.url')),
    path('transaccion/', include('Transacciones.url')),
    path('publicacion/', include('Publicaciones.url')),
    path('bolsillo/', include('bolsillo.url')),
    path('sumary/', include('Sumary.url')) 
]
