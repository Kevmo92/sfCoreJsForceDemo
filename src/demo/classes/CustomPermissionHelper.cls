public class CustomPermissionHelper extends APermissionHelper {
  private Set<String> customPermissions;
  private Set<String> currentUserPermissions;

  public override Boolean hasPermission(String permissionName) {
    if (this.customPermissions == null) {
      this.load();
    }

    if (!customPermissions.contains(permissionName)) {
      throw new CustomPermissionNotFoundException(
        String.format(PERMISSION_NOT_FOUND_MESSAGE, new List<String>{ permissionName })
      );
    }

    return this.currentUserPermissions.contains(permissionName);
  }

  public void load() {
    this.customPermissions = new Set<String>();
    this.currentUserPermissions = new Set<String>();
    Map<Id, String> customPermissionMap = new Map<Id, String>();

    // Get all custom permissions in the local package.
    String namespacePrefix = this.getLocalPackageNamespacePrefix();
    for (CustomPermission customPermission : this.getCustomPermissions(namespacePrefix)) {
      this.customPermissions.add(customPermission.DeveloperName);
      customPermissionMap.put(customPermission.Id, customPermission.DeveloperName);
    }

    // Get all custom permissions in the local package that are assigned to the current user.
    for (SetupEntityAccess setupEntity : this.getCurrentUserPermissions(customPermissionMap.keySet()))
      this.currentUserPermissions.add(customPermissionMap.get(setupEntity.SetupEntityId));
  }

  private String getLocalPackageNamespacePrefix() {
    return CustomPermissionHelper.class.getName().substringBefore('CustomPermissionHelper').substringBefore('.');
  }

  private CustomPermission[] getCustomPermissions(String namespacePrefix) {
    return [SELECT Id, DeveloperName FROM CustomPermission WHERE NamespacePrefix = :namespacePrefix];
  }

  private SetupEntityAccess[] getCurrentUserPermissions(Set<Id> customPermissionIds) {
    return [
      SELECT SetupEntityId
      FROM SetupEntityAccess
      WHERE
        SetupEntityId IN :customPermissionIds
        AND ParentId IN (SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId())
    ];
  }

  public class CustomPermissionNotFoundException extends Exception {}

  private static final String PERMISSION_NOT_FOUND_MESSAGE = 'Custom Permission ({0}) not found.';
}
