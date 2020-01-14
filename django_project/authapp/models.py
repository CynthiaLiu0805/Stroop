
# Create your models here.
from django.db import models
from django.contrib.auth.models import User
from django import forms


class UserInfoManager(models.Manager):
    def create_user_info(self, username, password, score,time):
        user = User.objects.create_user(username=username,
                                        password=password)
        userinfo = self.create(user=user)


        return userinfo
        
class UserInfo(models.Model):
   
    user = models.OneToOneField(User,
                                    on_delete=models.CASCADE,
                                    primary_key=True)
    
    score = models.IntegerField(default=0)

    time = models.FloatField(default=0)

    #info = models.CharField(max_length=30)

    objects = UserInfoManager()


