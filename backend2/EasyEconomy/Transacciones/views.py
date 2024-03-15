from django.shortcuts import render
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .serializer import TransaccionSerializer, TransaccionSaveSerializer
from rest_framework.generics import ListCreateAPIView
from .models import Transaccion

@api_view(['POST'])
def CrearTransaccion(request):
    #convierte los datos en Querydict especializdo para recibir los datos de la solicitud http
    data = request.data.dict()
    print(data)
    print(request.user)

    #Asignar la transaccion que corresponde a un ususario
    data['usuario']=request.user.id

    serializer = TransaccionSaveSerializer(data=data)
    if serializer.is_valid(raise_exception=True):
        transaccion = serializer.save()
        return Response(TransaccionSerializer(transaccion, many=False).data)
    return Response({})

#obtenemos la lista de transacciones del usuario
class ListarTransacciones(ListCreateAPIView):
    serializer_class = TransaccionSerializer
    queryset = Transaccion.objects.all()

    def get_queryset(self):
        queryset = Transaccion.objects.filter(usuario = self.request.user)
        return queryset

def ObtenerTransaccion(request):
    pass