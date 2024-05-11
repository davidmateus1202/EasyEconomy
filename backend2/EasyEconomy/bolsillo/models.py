from django.db import models
from django.contrib.auth import get_user_model

class Bolsillo(models.Model):
    usuario = models.ForeignKey(get_user_model(), on_delete=models.CASCADE)
    nombre_bolsillo = models.CharField(max_length=100)
    descripcion = models.CharField(max_length=1000)
    saldo = models.FloatField()
    fecha = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-fecha']

    def __str__(self):
        return f'Bolsillo de usuario: {self.usuario.username} con saldo de $ {self.saldo} nombre bolsillo: {self.nombre_bolsillo}'