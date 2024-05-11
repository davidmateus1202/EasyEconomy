from django.urls import path
from . import views




urlpatterns = [
    path('crearbolsillo/', views.CrearBolsillo),
    path('listarbolsillos/', views.ListarBolsillos.as_view()),

    



]