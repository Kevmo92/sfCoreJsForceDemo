public class Application {
  public static APermissionHelper Permissions = new CustomPermissionHelper();

  public static String generateLookupKey() {
    String returnVal = Math.random() + '';
    returnVal = returnVal.replace('0.', '42');
    return returnVal.substring(0, Math.min(returnVal.length(), 17));
  }
}
