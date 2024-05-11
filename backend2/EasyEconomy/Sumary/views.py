from django.shortcuts import render
from rest_framework.response import Response
from rest_framework.decorators import api_view
from .models import Saldo, Sumary

@api_view(['GET'])
def TotalSaldo(request):
    queryset = Saldo.objects.filter(usuario = request.user)
    print(queryset)
    return Response({'saldo': queryset[0].total_saldo})

@api_view(['GET'])
def TotalIngresosUser(request):
    queryset = Sumary.objects.filter(usuario = request.user)
    print(queryset)
    return Response({'total_ingresos': queryset[0].TotalIngresos})


