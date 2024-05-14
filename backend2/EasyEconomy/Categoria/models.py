from django.db import models


class Categorias(models.Model):
    Categoria = models.CharField(default='Gastos Fijos', max_length=255)

    def __str__(self):
        return f'{self.Categoria} {self.id}'

