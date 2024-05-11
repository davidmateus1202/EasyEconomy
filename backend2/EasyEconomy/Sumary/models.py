from django.db import models
from django.contrib.auth import get_user_model

class Saldo(models.Model):
    usuario = models.ForeignKey(get_user_model(), on_delete=models.CASCADE)
    total_saldo = models.DecimalField(max_digits=10, decimal_places=2)



class Sumary(models.Model):
    usuario = models.ForeignKey(get_user_model(), on_delete=models.CASCADE)
    TotalIngresos = models.DecimalField(max_digits=10, decimal_places=2)
