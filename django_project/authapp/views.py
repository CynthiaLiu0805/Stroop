from django.shortcuts import render
from django.shortcuts import redirect
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.models import User
from authapp.models import UserInfo
from django import forms
from django.http import HttpResponse, HttpResponseRedirect

import json



def mainpage(request):
    return HttpResponseRedirect("https://mac1xa3.ca/u/liuy363/project3.html")



def userlogin(request):
   
    json_req = json.loads(request.body.decode('utf-8'))
    username = json_req.get('username','')
    password = json_req.get('password','')
    if request.method == 'POST':
        
        user = authenticate(request, username=username, password=password)
        
        if user is None:
            
            return HttpResponse('LoginFailed')
        else:
            login(request, user)
            return HttpResponse('Success! Hello ' )

    else:
        return HttpResponseRedirect("https://mac1xa3.ca/u/liuy363/login.html")


def userlogout(request):
    logout(request)
    return HttpResponseRedirect("https://mac1xa3.ca/u/liuy363/project3.html")


def adduser(request):
    json_req = json.loads(request.body.decode('utf-8'))
    username = json_req.get('username','')
    password = json_req.get('password','')

    if username != '':
        user = User.objects.create_user(username=username,
                                        password=password)
        userinfo=UserInfo.objects.create(user=user)
        login(request,user)
        return HttpResponse('LoggedIn')

    else:
        return HttpResponse('LoggedOut')   


def user_info(request):
    if not request.user.is_authenticated:
        return HttpResponse("LoggedOut")
    else:
        user=request.user
        userinfo=UserInfo.objects.get(user=user)
        return HttpResponse("Hello " + request.user.username)






def myscore(request):
    if request.method == 'POST':
        score_data = json.loads(request.body.decode('utf-8'))
        print(str(score_data))
        #s=score_data[0]
        #a=score_data[1]
        score=score_data.get('score',0)
        #time=a['time']
        #print(str(time))
        user = request.user
        if user.is_authenticated:
            
            userinfo=UserInfo.objects.get(user=user)
            #userinfo.time=time
            #userinfo.save()
            if score>userinfo.score:
               
               userinfo.score=score
               userinfo.save()
               print(str(score_data))
               return HttpResponse('score updated')
            else:
               return HttpResponse('Not higher than highest')
        else:
            return HttpResponse("user not authenticated")
    
    else:
        return HttpResponse('fail to post')


def getscore(request):
   res=''
   qs=UserInfo.objects.order_by('score')
   for elt in qs:
     res += elt.name + '<br>'
   return HttpResponse(res)
