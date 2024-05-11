from rest_framework import serializers
from .models import Publicacion
from django.contrib.auth import get_user_model


class UsuarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = get_user_model()
        fields = ['id','username', 'email', 'imagen_profile']


class PublicacionSerializer(serializers.ModelSerializer):
    #obtenemos el nombre del ususario
    usuario = serializers.StringRelatedField()
    class Meta:
        model = Publicacion
        fields = '__all__'
        #campo de solo lectura 
        read_only_fields = ['fecha']


'''
class PublicacionSerializer(serializers.ModelSerializer):
    #obtenemos el nombre del ususario
    usuario = serializers.StringRelatedField()
    image_memoria = serializers.SerializerMethodField('memoria_imagen')
    class Meta:
        model = Publicacion
        fields = ['id', 'usuario', 'contenido', 'fecha', 'image', 'image_memoria']
        #campo de solo lectura 
        read_only_fields = ['fecha']

    def memoria_imagen(request, publicacion:Publicacion):
        with open(publicacion.image.path, 'rb') as loadedfile:
            image_data = loadedfile.read()
            base64_encoded_image = base64.b64encode(image_data).decode('utf-8')  # Codificar en Base64 y convertir a cadena
        return base64_encoded_image 

'''