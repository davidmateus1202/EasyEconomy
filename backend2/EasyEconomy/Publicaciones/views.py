from django.shortcuts import render
from rest_framework.decorators import api_view
from .models import Publicacion
from .serializer import PublicacionSerializer
from rest_framework.response import Response
from rest_framework.generics import ListCreateAPIView

# Crear vista para peticion post
@api_view(['POST'])
def CrearPublicacion(request):
    data = request.data.dict()
    print(data)
    data['usuario'] = request.user.id

    serializer = PublicacionSerializer(data=data)
    if serializer.is_valid(raise_exception=True):
        publicacion = serializer.save()
        return Response(PublicacionSerializer(publicacion, many=False).data)
    
    return Response({})

#obtener la lista de publicaciones de ususario

class ListarPublicacionesUsuario(ListCreateAPIView):
    serializer_class = PublicacionSerializer
    queryset = Publicacion.objects.all(),

    def get_queryset(self):
        queryset = Publicacion.objects.filter(usuario= self.request.user)
        return queryset