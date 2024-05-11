from django.shortcuts import render
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .serializer import TransaccionSerializer, TransaccionSaveSerializer
from rest_framework.generics import ListCreateAPIView
from .models import Transaccion
from django.contrib.auth import get_user_model
from django.db.models import Sum

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
    

    
@api_view(['GET'])
def ObtenerTransaccion(request, pk):
    
    if request.method == 'GET':
        user = get_user_model().objects.get(pk=pk)

        sumatoria = Transaccion.objects.filter(usuario = user, tipo = 'egreso').values('fecha__date').annotate(total=Sum('monto')).order_by('fecha__date')

        sumatoria_list = [{'fecha': item['fecha__date'], 'total': item['total']} for item in sumatoria]

        print(sumatoria_list)

        return Response(sumatoria_list, status=200)
    return Response({}, status=400)


@api_view(['GET'])
def ObtenerTotalIngresos(request, pk):

    if request.method == 'GET':
        user = get_user_model().objects.get(pk = pk)

        sumatoria = Transaccion.objects.filter(usuario = user, tipo = 'ingreso').aggregate(total = Sum('monto'))['total'] or 0

        return Response({'total': sumatoria}, status=200)