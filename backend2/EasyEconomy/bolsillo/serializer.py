from rest_framework import serializers
from .models import Bolsillo
from Transacciones.serializer import UsuarioSerializer


class BolsilloSerializer(serializers.ModelSerializer):
    usuario = serializers.SerializerMethodField("get_user")
    class Meta:
        model = Bolsillo
        fields = '__all__'
        #campo de solo lectura
        read_only_fields = ['fecha']
    
    def get_user(self, model: Bolsillo):
        return UsuarioSerializer(model.usuario, many=False).data
