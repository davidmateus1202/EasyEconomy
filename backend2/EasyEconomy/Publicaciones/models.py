from django.db import models
from django.contrib.auth import get_user_model


class Publicacion(models.Model):
    usuario = models.ForeignKey(get_user_model(), on_delete=models.CASCADE)
    contenido = models.TextField()
    fecha = models.DateTimeField(auto_now_add=True)
    image = models.URLField(blank=True, null=True)

    class Meta:
        ordering = ['-fecha']

    def __str__(self):
        return f'Publicacion de usuario: {self.usuario.username}, fecha {self.fecha}'