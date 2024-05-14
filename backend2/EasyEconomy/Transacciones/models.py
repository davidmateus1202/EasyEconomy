from django.db import models
from django.contrib.auth import get_user_model
from Categoria.models import Categorias

class Transaccion(models.Model):
    usuario = models.ForeignKey(get_user_model(), on_delete=models.CASCADE)
    id_Categoria = models.ForeignKey(Categorias, on_delete=models.CASCADE, null=True)
    tipo = models.CharField(max_length=255)
    monto = models.FloatField()
    descripcion = models.CharField(max_length=255)
    fecha = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-fecha']
   

    def __str__(self):
        return f'Transaccion de ususario: {self.usuario.username} por el monto $ {self.monto} de tipo {self.tipo}'
