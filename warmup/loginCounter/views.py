from django.shortcuts import get_object_or_404, render_to_response
from django.http import HttpResponseRedirect, HttpResponse
from django.core.urlresolvers import reverse
from django.template import RequestContext

from loginCounter.models import UserModels
from django.utils import simplejson
from django.views.decorators.csrf import csrf_exempt

SUCCESS               =   1  # : a success
ERR_BAD_CREDENTIALS   =  -1  # : (for login only) cannot find the user/password pair in the database
ERR_USER_EXISTS       =  -2  # : (for add only) trying to add a user that already exists
ERR_BAD_USERNAME      =  -3  # : (for add, or login) invalid user name (only empty string is invalid for now)
ERR_BAD_PASSWORD      =  -4

@csrf_exempt
def login(request):
    if request.is_ajax() and request.method == 'POST':
        json_data = simplejson.loads(request.body)
    username = json_data['user']
    password = json_data['password']

    count = UserModels().login(username, password)

    response_data = {}
    if count > 0:
        response_data = {
                'errCode' : SUCCESS,
                'count'   : count
            }
    else:
        response_data['errCode'] = count
        
    return HttpResponse(simplejson.dumps(response_data), content_type="application/json")

@csrf_exempt
def add(request):
    if request.is_ajax() and request.method == 'POST':
        json_data = simplejson.loads(request.body)

    username = json_data['user']
    password = json_data['password']

    count = UserModels().add(username, password)

    response_data = {}
    if count > 0:
        response_data = {
                'errCode' : SUCCESS,
                'count'   : count
            }
    else:
        response_data['errCode'] = count
        
    return HttpResponse(simplejson.dumps(response_data), content_type="application/json")

@csrf_exempt
def resetFixture(request):
    UserModels().TESTAPI_resetFixture()
    response_data = {'errCode' : 1}
    return HttpResponse(simplejson.dumps(response_data), content_type="application/json")

@csrf_exempt
def unitTests(request):
    rv = UserModels().TESTAPI_unitTests()
    return HttpResponse(simplejson.dumps(rv), content_type = "application/json")
