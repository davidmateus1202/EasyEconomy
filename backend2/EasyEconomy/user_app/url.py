from django.urls import path, include
from .views import UserDetailView, user_detail


urlpatterns = [

    path('auth/', include('dj_rest_auth.urls')),
    path('registration/', include('dj_rest_auth.registration.urls')),
    path('user_detail/', user_detail),
    path('actualizar_usuario/<int:pk>/', UserDetailView.as_view() )
    

]