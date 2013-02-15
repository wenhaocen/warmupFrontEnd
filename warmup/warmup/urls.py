from django.conf.urls import patterns, include, url
from django.views.generic import DetailView, ListView
from loginCounter.models import UserModels

from django.contrib.staticfiles.urls import staticfiles_urlpatterns
from django.conf import settings

# Uncomment the next two lines to enable the admin:
# from django.contrib import admin
# admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'warmup.views.home', name='home'),
    # url(r'^warmup/', include('warmup.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    # url(r'^admin/', include(admin.site.urls)),
                       
    #url(r'^client.html/$', 'loginCounter.views.client'),

    url(r'^users/login$', 'loginCounter.views.login'),
    url(r'^users/add$', 'loginCounter.views.add'),
    url(r'^TESTAPI/resetFixture$', 'loginCounter.views.resetFixture'),
    url(r'^TESTAPI/unitTests$', 'loginCounter.views.unitTests'),
)

#urlpatterns += staticfiles_urlpatterns()
if settings.DEBUG:
    urlpatterns += patterns('',
        (r'^(?P<path>.*)$', 'django.views.static.serve',  
         {'document_root':     settings.STATIC_URL}),
    )
