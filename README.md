# Demo repo for sf core vs jsforce

Repo was created for the purpose of showing the difference between installing a package with the tooling api after connecting with either sf core or jsforce

When installing a package with a jsforce connection and then running a unit test involving custom permissions the custom permissions are being applied to profiles even with the SecurityType set to None
