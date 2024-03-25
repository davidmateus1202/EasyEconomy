from django.urls import path
from . import views

urlpatterns = [

    path('crearPublicacion/', views.CrearPublicacion),
    path('listarPublicacionUsuario/', views.ListarPublicacionesUsuario.as_view()),
    path('listarPublicaciones/', views.ListarPublicaciones.as_view()),

]