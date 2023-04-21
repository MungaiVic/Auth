from rest_framework.urls import path

from .views import index

urlpatterns = [
    path('', index, name='index'),
]