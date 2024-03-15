from django.db import models
from django.contrib.auth.models import User, AbstractUser
from django_resized import ResizedImageField


def upload_to( inst, filename):
    return "/profile"+str(filename)

class UserModel(AbstractUser):
    username = models.CharField(max_length=255, unique=True)
    foto_perfil = ResizedImageField(upload_to=upload_to, null=True, blank=True)

    class Meta(AbstractUser.Meta):
        swappable = 'AUTH_USER_MODEL'

    def __str__(self) -> str:
        return f'{self.username} {self.id}'

    

