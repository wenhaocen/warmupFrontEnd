from django.db import models
from django.db import IntegrityError
import StringIO
import tests
from django.utils import unittest

# Create your models here.

SUCCESS               =   1  # : a success
ERR_BAD_CREDENTIALS   =  -1  # : (for login only) cannot find the user/password pair in the database
ERR_USER_EXISTS       =  -2  # : (for add only) trying to add a user that already exists
ERR_BAD_USERNAME      =  -3  # : (for add, or login) invalid user name (only empty string is invalid for now)
ERR_BAD_PASSWORD      =  -4

MAX_USERNAME_LENGTH = 128
MAX_PASSWORD_LENGTH = 128

class UserModels(models.Model):
    username = models.CharField(max_length=MAX_USERNAME_LENGTH, primary_key=True)
    password = models.CharField(max_length=MAX_PASSWORD_LENGTH, blank=True, null=True)
    count = models.IntegerField()

    def __unicode__(self):
        return "Username: " + self.username + " \n" + "Password: " + self.password + " \n" + "Count: " + self.count + "\n"   

    # int login(string user, string password); 
    #   This function checks the user/password in the database. 
    #   On success, the function updates the count of logins in the database.
    #   On success the result is either the number of logins (including this one) (>= 1)
    #   On failure the result is an error code (< 0) from the list below
    def login(self, user, passwd):  
        try:
            user = UserModels.objects.get(username=user)
            if user.password != passwd:
                return ERR_BAD_CREDENTIALS
        except UserModels.DoesNotExist, e:
            return ERR_BAD_CREDENTIALS
        user.count += 1
        user.save()
        return user.count        

    # int add(string user, string password);
    #   This function checks that the user does not exists, the user name is not empty. (the password may be empty). 
    #   On success the function adds a row to the DB, with the count initialized to 1
    #   On success the result is the count of logins
    #   On failure the result is an error code (<0) from the list below
    def add(self, user, passwd):
        if user == "" or len(user) > MAX_USERNAME_LENGTH:
            return ERR_BAD_USERNAME
        if len(passwd) > MAX_PASSWORD_LENGTH:
            return ERR_BAD_PASSWORD
        
        try:
            newUser = UserModels.objects.get(username=user)
        except UserModels.DoesNotExist, e:
            newUser = UserModels(username=user, password=passwd, count=1)
            newUser.save()
            return newUser.count
        return ERR_USER_EXISTS


    #    int TESTAPI_resetFixture();
    #        Reset the database to the empty state.
    #        Used for testing
    def TESTAPI_resetFixture(self):
        UserModels.objects.all().delete()

    def TESTAPI_unitTests(self):
        buffer = StringIO.StringIO()
        suite = unittest.TestLoader().loadTestsFromTestCase(tests.TestUsers)
        result = unittest.TextTestRunner(stream = buffer, verbosity = 2).run(suite)

        rv = {"totalTests": result.testsRun, "nrFailed": len(result.failures), "output": buffer.getvalue()}
        return rv
 
