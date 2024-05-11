from dj_rest_auth.serializers import LoginSerializer
from dj_rest_auth.registration.serializers import RegisterSerializer
from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import UserModel

UserModel = get_user_model()

class RegistroSerializer(RegisterSerializer):
    def custom_signup(self, request, user):
        pass



class LoginSerializer(LoginSerializer):
    pass


class UsuarioProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserModel
        fields = '__all__'