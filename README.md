# DataPack Loader

Snowfakery can generate "DataPack" in a JSON format compatible with the Apex
Classes in this Repository.

## Usage

Once installed, the DataPack Loader can be accessed from any Flow or Apex.

You can load data from Apex with the method called `LoadCompositeAPIData.loadJsonSet` as
shown in the file `scripts/apex/DemoJSONData.apex`

You can load data from Flows by calling the Apex action called
`Load Snowfakery Data Bundle` and passing a Data Bundle URL to the parameter called
`json_url`. Here is a JSON bundle URL you could try:

```
https://gist.githubusercontent.com/prescod/85efa2b30e52c4ca97d24f5a61631aa4/raw/4e293e07877d63b965f2c75f6bf2edafea3230b4/composite.json
```

## Running a Demo of the Feature

Running a demo entails these steps:

1. Create a scratch org
2. Deploy the classes with CumulusCI or SFDX
3. Make it possible for your org to reach out to Github's Gists website to download the sample data by creating a Remote Site Setting.
4. Run an Anonymous Apex that actually does the load.

### Steps 1 and 2: Deploying with CumulusCI

The Classes can be deployed to your org using CumulusCI or SFDX.

Starting with CumulusCI:

```sh
$ cci task run deploy --org <cci orgname>
```

For example:

```sh
$ cci org scratch dev dev
$ cci task run deploy --org dev
```

Or on Windows:

```sh
C:\> cci org scratch dev dev
C:\> cci task run deploy --org dev
```

### Alternate: Deploying with SFDX

```sh
$ sfdx force:source:deploy -p force-app -u <sfdx username or alias>
```

For example:

```sh
$ sfdx force:org:create -f orgs/dev.json  -a MyScratchOrg
$ sfdx force:source:deploy -p force-app -u MyScratchOrg
```

### Step 3: Creating or deploying a Remote Site Setting

Salesforce is only allowed to download data from third party sites if an administrator allows it to with Remote Site Settings. You can learn more about Remote Site Settings on the [Salesforce Site](https://help.salesforce.com/s/articleView?id=sf.configuring_remoteproxy.htm&language=en_US&r=https%3A%2F%2Fwww.google.com%2F&type=5). 

If you want to configure it yourself, the URL to configure is `https://gist.githubusercontent.com`. We recommend doing this on Scratch orgs instead of on your prod or sandbox.

Note that you alone are responsible for the security implications of opening up Salesforce to download data from `gist.githubusercontent.com`. We would not suggest it if we thought it was in any way dangerous, but you are nevertheless the expert about your own company's security requirements.

#### Deploying the Remote Site Setting with CumulusCI

If you would like to deploy the Remote Site Setting from a Command Line Interface, you can do so like this:

```s
$ cci task run deploy --org dev --path Github_Gists_RemoteSiteSetting
```

("dev" should be replaced with your own org's CumulusCI alias)
#### Deploying the Remote Site Setting with SFDX

Or you can use SFDX:

```s
$ sfdx force:source:deploy -p Github_Gists_RemoteSiteSetting -u MyScratchOrg
```

### Step 4: Using Anonymous Apex 

Now you can actually deploy the DataPacks

Take a look over what is in the Apex script and then run it.

```s
$ cat scripts/apex/DemoJSONData.apex
...
$ cci task run execute_anon --path scripts/apex/DemoJSONData.apex --org dev
```

### Optional Step: Turning off Duplicate Rules

If you need to load a DataPack which could have duplicate entries, or you need to load
the same DataPack twice, you can turn off
Duplicate Rules in the [Salesforce User Interface](https://powerofus.force.com/s/article/EDA-Disable-Matching-Rules) 
or from the Command Line.


```s
$ cci task run set_duplicate_rule_status --active False --org dev
```

Either way, you should probably only do this in Scratch or Sandbox orgs, not Production!

### All at once

CumulusCI can string multiple actions together into a "flow". This project has a demo
flow that does all of those steps for you.

```sh
$ cci org scratch_delete dev
$ cci org scratch dev dev
$ cci flow run test_in_scratch_org --org dev
```

Or on Windows:

```sh
C:\> cci org scratch_delete dev
C:\> cci org scratch dev dev
C:\> cci flow run test_in_scratch_org --org dev
```

To protect your production orgs, this flow is configured to only deploy
data and settings to Scratch orgs.
