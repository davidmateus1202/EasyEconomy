from django.urls import path
from . import views

urlpatterns = [

    path('crearPublicacion/', views.CrearPublicacion),
    path('listarPublicacion/', views.ListarPublicacionesUsuario.as_view())

]