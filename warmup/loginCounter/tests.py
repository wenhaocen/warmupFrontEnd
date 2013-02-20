"""
This file demonstrates writing tests using the unittest module. These will pass
when you run "manage.py test".

Replace this with more appropriate tests for your application.
"""

#from django.test import TestCase
from django.utils.unittest import TestCase
import models

SUCCESS               =   1  # : a success
ERR_BAD_CREDENTIALS   =  -1  # : (for login only) cannot find the user/password pair in the database
ERR_USER_EXISTS       =  -2  # : (for add only) trying to add a user that already exists
ERR_BAD_USERNAME      =  -3  # : (for add, or login) invalid user name (only empty string is invalid for now)
ERR_BAD_PASSWORD      =  -4

class TestUsers(TestCase):
    """
    Unittests for the Users model class (a sample, incomplete)
    """
    def setUp(self):
        models.UserModels().TESTAPI_resetFixture()


    def testAdd1(self):
        """
        Tests that adding a user works
        """
        self.assertEquals(SUCCESS, models.UserModels().add("user1", "password"))
        
    def testAddExists(self):
        """
        Tests that adding a duplicate user name fails
        """
        self.assertEquals(SUCCESS, models.UserModels().add("user1", "password"))
        self.assertEquals(ERR_USER_EXISTS, models.UserModels().add("user1", "password"))

    def testAdd2(self):
        """
        Tests that adding two users works
        """
        self.assertEquals(SUCCESS, models.UserModels().add("user1", "password"))
        self.assertEquals(SUCCESS, models.UserModels().add("user2", "password"))

    def testAddEmptyUsername(self):
        """
        Tests that adding an user with empty username fails
        """
        self.assertEquals(ERR_BAD_USERNAME, models.UserModels().add("", "password"))

    def testAddEmptyPassword(self):
        """
        Tests that adding a user with empty password works
        """
        self.assertEquals(SUCCESS, models.UserModels().add("user", ""))

    def testLogin(self):
        """
        Tests that login works
        """
        self.assertEquals(SUCCESS, models.UserModels().add("user", ""))
        self.assertEquals(2, models.UserModels().login("user", ""))

    def testLoginEmptyUsername(self):
        """
        Tests that adding an user with empty username fails
        """
        self.assertEquals(ERR_BAD_CREDENTIALS, models.UserModels().login("", "password"))

    def testLoginTwice(self):
        """
        Tests that login twice works and count = 2
        """
        self.assertEquals(SUCCESS, models.UserModels().add("user", ""))
        self.assertEquals(2, models.UserModels().login("user", ""))
        self.assertEquals(3, models.UserModels().login("user", ""))

    def testDifferentUserSamePassword(self):
        """
        Tests that two users can have the same password
        """
        self.assertEquals(SUCCESS, models.UserModels().add("user1", ""))
        self.assertEquals(SUCCESS, models.UserModels().add("user2", ""))

    def testLoginWithWrongPassword(self):
        """
        Tests login with wrong password
        """
        self.assertEquals(SUCCESS, models.UserModels().add("user", "password"))
        self.assertEquals(ERR_BAD_CREDENTIALS, models.UserModels().login("user", ""))
        
    def testLoginInvalidUser(self):
        """
        Tests that login with invalid user doesn't work
        """
        self.assertEquals(ERR_BAD_CREDENTIALS, models.UserModels().login("user", ""))

    def testBadUsername(self):
        """
        Tests that adding bad username doesn't work
        """
        username = 'a' * 130
        self.assertEquals(ERR_BAD_USERNAME, models.UserModels().add(username, ""))

    def testBadPassword(self):
        """
        Tests that adding bad password doesn't work
        """
        password = 'a' * 130
        self.assertEquals(ERR_BAD_PASSWORD, models.UserModels().add("user", password))

    def testResetFixture(self):
        """
        Tests that resetFixture will empty DB
        """
        self.assertEquals(SUCCESS, models.UserModels().add("user", ""))
        self.assertEquals(2, models.UserModels().login("user", ""))
        self.assertEquals(len(models.UserModels.objects.all()), 1)
        models.UserModels().TESTAPI_resetFixture()
        self.assertEquals(len(models.UserModels.objects.all()), 0)
