from django.shortcuts import render
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .serializer import TransaccionSerializer, TransaccionSaveSerializer
from rest_framework.generics import ListCreateAPIView
from .models import Transaccion
from django.contrib.auth import get_user_model
from django.db.models import Sum
from datetime import datetime
from django.utils import timezone  



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



class ListarGastosFijos(ListCreateAPIView):
    serializer_class = TransaccionSerializer
    queryset = Transaccion.objects.all()

    def get_queryset(self):
        queryset = Transaccion.objects.filter(usuario = self.request.user, id_Categoria = 1)
        return queryset


@api_view(['GET'])
def getTotalIngresos(request, pk):

    if request.method == 'GET':
        user = get_user_model().objects.get(pk = pk)

        # Obtener la fecha actual
        today = timezone.now()

        # Obtener el primer día del mes actual
        first_day_of_month = today.replace(day=1, hour=0, minute=0, second=0, microsecond=0)

        # Obtener el último día del mes actual
        next_month = first_day_of_month.replace(month=first_day_of_month.month+1)
        last_day_of_month = next_month - timezone.timedelta(days=1)

        # Filtrar las transacciones del usuario para el mes actual
        transacciones_mes_actual = Transaccion.objects.filter(
            usuario=user,
            tipo='ingreso',
            fecha__range=(first_day_of_month, last_day_of_month)
        )

        # Calcular el total de ingresos para el mes actual
        total_ingresos = transacciones_mes_actual.aggregate(total=Sum('monto'))['total'] or 0
        total_gastos_fijos = total_ingresos * 0.5
        total_gastos_variables = total_ingresos * 0.3
        total_ahorro = total_ingresos * 0.2


        return Response({'total': total_ingresos, 'Gastos_Fijos': total_gastos_fijos, 'Gastos_variables': total_gastos_variables, 'Ahorro':total_ahorro}, status=200)
    return Response({}, status=400)
    


@api_view(['GET'])
def getExpense(request, pk):
    try:
        user = get_user_model().objects.get(pk=pk)

        # Obtener la fecha actual
        today = timezone.now()

        # Obtener el primer día del mes actual
        first_day_of_month = today.replace(day=1, hour=0, minute=0, second=0, microsecond=0)

        # Obtener el primer día del siguiente mes
        if first_day_of_month.month == 12:
            next_month = first_day_of_month.replace(year=first_day_of_month.year + 1, month=1)
        else:
            next_month = first_day_of_month.replace(month=first_day_of_month.month + 1)

        # Obtener el último día del mes actual
        last_day_of_month = next_month - timezone.timedelta(days=1)

        # Filtrar las transacciones del usuario para el mes actual
        transacciones_mes_actual = Transaccion.objects.filter(
            usuario=user,
            tipo='egreso',
            fecha__range=(first_day_of_month, last_day_of_month)
        )

        # Calcular el total de egresos para el mes actual
        total_egresos = transacciones_mes_actual.aggregate(total=Sum('monto'))['total'] or 0
        return Response({'total': total_egresos}, status=200)
    except get_user_model().DoesNotExist:
        return Response({'error': 'User not found'}, status=404)
    except Exception as e:
        return Response({'error': str(e)}, status=500)