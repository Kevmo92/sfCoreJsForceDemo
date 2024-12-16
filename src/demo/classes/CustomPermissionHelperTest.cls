@IsTest
public class CustomPermissionHelperTest {
  @IsTest
  private static void testHasPermission_CustomPermissionNotAssigned() {
    Test.startTest();
    Boolean actualValue = true;
    System.runAs(UnitTestUtility.createUser('testUser', 'custom.perm.help.no.permission@plm.force', 'Standard User')) {
      actualValue = new CustomPermissionHelper().hasPermission(LOCAL_CUSTOM_PERMISSION);
    }
    Test.stopTest();

    System.assertEquals(false, actualValue);
  }

  private static final String LOCAL_CUSTOM_PERMISSION = 'Generate_Release_Notes';
}