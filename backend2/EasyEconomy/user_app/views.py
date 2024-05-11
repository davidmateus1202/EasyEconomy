from django.shortcuts import render
from rest_framework.response import Response
from rest_framework.decorators import api_view, authentication_classes, permission_classes
from django.contrib.auth import get_user_model
from Transacciones.serializer import UsuarioSerializer
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView
from rest_framework.authtoken.models import Token
from .serializer import UsuarioProfileSerializer
from .models import UserModel

@api_view(['GET'])
def user_detail(request):

    token = request.headers.get('Authorization').split(' ')[1]
    try:
        auth_token = Token.objects.get(key=token)
        usuario = auth_token.user
        serializer = UsuarioProfileSerializer(usuario)
        return Response(serializer.data, status=200)
    except Token.DoesNotExist:
        return Response({'message': 'Token inválido'}, status=400)
    except UserModel.DoesNotExist:
        return Response({'message': 'El usuario no existe'}, status=404)

 
class UserDetailView(APIView):
    def put(self, request, pk):
        try:
            usuario = get_user_model().objects.get(pk=pk)
        except get_user_model().DoesNotExist:
            return Response({'message': 'El usuario no existe'}, status=404)
        serializar = UsuarioSerializer(usuario, data=request.data)
        if serializar.is_valid():
            if 'imagen_profile' in request.data:
                usuario.imagen_profile = request.data['imagen_profile']
            serializar.save()
            usuario.save()
            return Response(serializar.data, status=200)
        else:
            return Response(serializar.errors, status=400)
        