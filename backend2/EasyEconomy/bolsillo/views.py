from django.shortcuts import render
from rest_framework.decorators import api_view
from .serializer import BolsilloSerializer
from rest_framework.response import Response
from django.shortcuts import get_object_or_404
from user_app import models
from .models import Bolsillo
from rest_framework.generics import ListCreateAPIView
from django.contrib.auth import get_user_model



@api_view(['POST'])
def CrearBolsillo(request):
    usuario_id = request.data.get('usuario')
    saldo = request.data.get('saldo')
    nombre_bolsillo = request.data.get('nombre_bolsillo')
    descripcion = request.data.get('descripcion')

    usuario = get_object_or_404(models.UserModel, id=usuario_id)
    bolsillo = Bolsillo(usuario=usuario, saldo=saldo, nombre_bolsillo=nombre_bolsillo, descripcion=descripcion)
    bolsillo.save()
    serializer = BolsilloSerializer(bolsillo)
    return Response(serializer.data)


class ListarBolsillos(ListCreateAPIView):
    serializer_class = BolsilloSerializer
    queryset = Bolsillo.objects.all()


    def get_queryset(self):
        queryset = Bolsillo.objects.filter(usuario = self.request.user)
        return queryset