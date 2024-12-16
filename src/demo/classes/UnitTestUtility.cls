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

  @TestVisible
  private static User createUser(String userAlias, String userName, String profileName, String[] permissionSets) {
    User newUser = UnitTestUtility.createUser(userAlias, userName, profileName);

    PermissionSetAssignment[] assignments = new List<PermissionSetAssignment>{};

    for (String permissionSetName : permissionSets) {
      PermissionSet permSet = UnitTestUtility.getPermissionSet(permissionSetName);
      assignments.add(new PermissionSetAssignment(AssigneeId = newUser.Id, PermissionSetId = permSet.Id));
    }

    insert assignments;
    return newUser;
  }

  @TestVisible
  private static User getUser(String alias) {
    return [SELECT Id, Name FROM User WHERE Alias = :alias LIMIT 1];
  }

  @TestVisible
  private static PermissionSet getPermissionSet(String name) {
    return [SELECT Id, Name FROM PermissionSet WHERE Name = :name LIMIT 1];
  }
}
