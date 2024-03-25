from django.shortcuts import get_object_or_404, render
from rest_framework.decorators import api_view

from user_app import models
from .models import Publicacion
from .serializer import PublicacionSerializer
from rest_framework.response import Response
from rest_framework.generics import ListCreateAPIView
from django.core.files.base import ContentFile

# Crear vista para peticion post
@api_view(['POST'])
def CrearPublicacion(request):
    usuario_id = request.data.get('usuario')
    contenido = request.data.get('contenido')
    image = request.data.get('image')

    usuario = get_object_or_404(models.UserModel, id=usuario_id)
    publicacion = Publicacion(usuario=usuario, contenido=contenido, image=image)

    publicacion.save()
    serializer = PublicacionSerializer(publicacion)
    return Response(serializer.data)

#obtener la lista de publicaciones de ususario

class ListarPublicacionesUsuario(ListCreateAPIView):
    serializer_class = PublicacionSerializer
    queryset = Publicacion.objects.all(),

    def get_queryset(self):
        queryset = Publicacion.objects.filter(usuario= self.request.user)
        return queryset
    

#obtener la lista de publicaciones de ususario
class ListarPublicaciones(ListCreateAPIView):
    serializer_class = PublicacionSerializer
    queryset = Publicacion.objects.all()