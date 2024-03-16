from rest_framework import serializers
from .models import Publicacion
from django.contrib.auth import get_user_model

class UsuarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = get_user_model()
        fields = ['id','username', 'email']


class PublicacionSerializer(serializers.ModelSerializer):
    usuario = serializers.SerializerMethodField("get_usuario")
    class Meta:
        model = Publicacion
        fields = '__all__'
        #campo de solo lectura 
        read_only_fields = ['fecha']

    def get_usuario(self, model: Publicacion):
        return UsuarioSerializer(model.usuario, many=False).data