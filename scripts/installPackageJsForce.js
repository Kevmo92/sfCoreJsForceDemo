import { Connection } from '@jsforce/jsforce-node';
import { waitForPublish } from '@salesforce/packaging/lib/package/packageInstall.js';

async function monitorInstallation(conn, installId) {
  let status = '';
  while (status !== 'SUCCESS' && status !== 'ERROR') {
    const result = await conn.tooling.sobject('PackageInstallRequest').retrieve(installId);

    status = result.Status;
    console.log(`Installation Status: ${status}`);

    if (status === 'ERROR') {
      throw new Error(`Installation failed: ${result.ErrorMessage}`);
    }

    await new Promise((resolve) => setTimeout(resolve, 5000));
  }
}

async function installPackage() {
  const conn = new Connection({
    accessToken: process.env.SF_ACCESS_TOKEN,
    instanceUrl: process.env.SF_INSTANCE_URL,
  });
  const packageId = process.env.PACKAGE_VERSION_ID;

  try {
    if (!packageId) {
      throw new Error('PACKAGE_VERSION_ID is not defined');
    }

    await waitForPublish(conn, packageId, 5000, 60000);

    console.log('Package published successfully');
  } catch (error) {
    console.error('Error waiting for package publish:', error);
    throw error;
  }

  try {
    const response = await conn.tooling.sobject('PackageInstallRequest').create({
      SubscriberPackageVersionKey: packageId,
      NameConflictResolution: 'Block',
      SecurityType: 'None',
      ApexCompileType: 'package',
      SkipHandlers: 'FeatureEnforcement',
    });

    await monitorInstallation(conn, response.id);
    console.log('Package installation completed successfully');
  } catch (error) {
    console.error('Installation failed:', error.message);
    process.exit(1);
  }
}

installPackage();
