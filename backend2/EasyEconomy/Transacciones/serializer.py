from rest_framework import serializers
from .models import Transaccion
from django.contrib.auth import get_user_model

class UsuarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = get_user_model()
        fields = ['id','username', 'email']


class TransaccionSerializer(serializers.ModelSerializer):
    usuario =serializers.SerializerMethodField("get_usuario")
    class Meta:
        model = Transaccion
        fields = '__all__'
        #campo de solo lectura 
        read_only_fields = ['fecha']
    
    def get_usuario(self, model: Transaccion):
        return UsuarioSerializer(model.usuario, many=False).data
    
# guardar la transaccion del usuario
    
class TransaccionSaveSerializer(serializers.ModelSerializer):
    class Meta:
        model = Transaccion
        fields = '__all__'
        #campo de solo lectura 
        read_only_fields = ['fecha']



