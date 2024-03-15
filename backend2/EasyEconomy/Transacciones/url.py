from django.urls import path
from . import views


urlpatterns = [

    path('crearTransaccion/', views.CrearTransaccion),
    path('getTransacciones/', views.ListarTransacciones.as_view()),
    path('obtenerTransaccion/', views.ObtenerTransaccion),

]