from django.urls import path
from . import views


urlpatterns = [

    path('crearTransaccion/', views.CrearTransaccion),
    path('getTransacciones/', views.ListarTransacciones.as_view()),
    path('getGastosFijos/', views.ListarGastosFijos.as_view()),
    path('obtenerTransaccion/<int:pk>/', views.ObtenerTransaccion),
    path('obtenerTotalIngresos/<int:pk>/', views.getTotalIngresos),
    path('getExpese/<int:pk>/', views.getExpense),

]