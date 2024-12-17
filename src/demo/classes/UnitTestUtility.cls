@isTest
public with sharing class UnitTestUtility {
  @TestVisible
  private static User createUser(String userAlias, String userName, String profileName) {
    Id profileId = [SELECT Id FROM Profile WHERE Name = :profileName].Id;
    User newUser = new User();
    newUser.alias = userAlias;
    newUser.email = 'unit.test.utility@plm.force';
    newUser.emailencodingkey = 'UTF-8';
    newUser.lastname = 'Testing';
    newUser.languagelocalekey = 'en_US';
    newUser.localesidkey = 'en_US';
    newUser.profileid = ProfileId;
    newUser.timezonesidkey = 'America/New_York';
    newUser.username = userName;

    insert newUser;
    return newUser;
  }
}
