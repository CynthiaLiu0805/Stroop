from django.urls import path,include
from . import views

app_name = 'authapp'
urlpatterns = [
   
    path('userlogin/', views.userlogin , name = 'authapp-userlogin'),
    path('logout/', views.userlogout , name = 'userlogout'),
    path('adduser/', views.adduser , name = 'adduser'),
    path('myscore/', views.myscore , name = 'score'),

]

