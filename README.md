# Learn Couchbase Lite with Dart and Flutter 

In this learning path you will be reviewing an Android and iOS Application written in Dart and Flutter that uses the community Couchbase Lite SDK for Dart and Flutter. You will learn how to get and insert documents using the key-value engine, query the database using the QueryBuilder engine or SQL++, and learn how to sync information between your mobile app and either a Couchbase Server using Sync Gateway or using peer-to-peer technology.

Full documentation can be found on the [Couchbase Developer Portal](https://developer.couchbase.com/learn/).

>**Note**:  The <a target="_blank" rel="noopener noreferrer"  href="https://github.com/cbl-dart/cbl-dart">Dart SDK for Couchbase Lite</a> is a community based project on GitHub and is not officially supported by Couchbase.  If you have questions or issues with the SDK, please <a target="_blank" rel="noopener noreferrer"  href="https://github.com/cbl-dart/cbl-dart/discussions">post them on the GitHub project</a>.

## Prerequisites

Before you get started you should take the following prerequisites into consideration:

- Familiarity with building <a target="_blank" rel="noopener noreferrer"  href="https://dart.dev/">Dart</a> and <a target="_blank" rel="noopener noreferrer"  href="https://flutter.dev">Flutter</a> Apps
- Familiarity with <a target="_blank" rel="noopener noreferrer"  href="https://bloclibrary.dev/">Bloc</a> and <a target="_blank" rel="noopener noreferrer"  href="https://bloclibrary.dev/#/architecture">statement management patterns</a> in Flutter
- Android SDK installed and setup (> v.32.0.0)
- Android Build Tools (> v.32.0.0)
- XCode 13 or later installed and setup 
- Android device or emulator running API level 23 (Android 6.0 Marshmallow) or above
- iOS device or simulator setup for iOS 14 or later
- IDE of choice (IntelliJ, Android Studio, VS Code, etc.)
- Flutter > 3.0 installed, setup, and configured for your IDE of choice

- curl HTTP client 
  * You could use any HTTP client of your choice. But we will use *curl* in our tutorial. Mac OS Package Manager users can use <a target="_blank" rel="noopener noreferrer" href="https://brew.sh/">homebrew</a>. Windows Package Manager users can use <a target="_blank" rel="noopener noreferrer" href="https://docs.microsoft.com/en-us/windows/package-manager/winget/">winget</a>. 

## Demo Application 

### Overview

The demo application used in this learning path is based on auditing <a target="_blank" rel="noopener noreferrer" href="https://en.wikipedia.org/wiki/Inventory">inventory</a> in various warehouses for a fictitious company.  Most companies have some inventory - from laptops to office supplies and must audit their stock from time to time. For example, when a user's laptop breaks, the Information Technology department can send out a replacement from the inventory of spare laptops they have on hand. In this app, the items we are auditing are cases of beer.  

Users running the mobile app would log into the application to see the projects they are assigned to work on. Then, the user would look at the project to see which warehouse they need to travel to. Once at the warehouse, they would inspect the number of cases of beer, tracking them in the mobile application.  Finally the data can be synced back to the server for use with other analytical data.

### Architecture

The demo application uses <a target="_blank" rel="noopener noreferrer" href="https://bloclibrary.dev/#/">bloc</a>, a very popular <a target="_blank" rel="noopener noreferrer"  href="https://bloclibrary.dev/#/architecture">statement management pattern</a>for Dart. 

Bloc is used to manage dependency inversion, injection, and state management.  Repositories and Services are registered using Bloc's <a target="_blank" rel="noopener noreferrer" href="https://pub.dev/documentation/flutter_bloc/latest/flutter_bloc/MultiRepositoryProvider-class.html">MultiRepositoryProvider</a>.  The sample application is broken down into features which can be found in the src/lib/features directory.

The <a target="_blank" rel="noopener noreferrer" href="https://github.com/couchbase-examples/flutter_cbl_learning_path/blob/main/src/lib/features/database/database_provider.dart">Database Provider</a>, found in the src/lib/features/database/ diretory, is a custom class that manages the database state and lifecycle.  Querying and updating documents in the database is handled using the <a target="_blank" rel="noopener noreferrer" href="https://bloclibrary.dev/#/architecture?id=repository">repository pattern</a>.  Blocs will query or post updates to the repository and control the state of objects that the Flutter widgets can use to display information. 

### Application Flow

The application structure starts with the <a target="_blank" rel="noopener noreferrer" href="https://github.com/couchbase-examples/flutter_cbl_learning_path/blob/main/src/lib/main.dart#L15">main function</a>.  It creates an <a target="_blank" rel="noopener noreferrer" href="https://github.com/couchbase-examples/flutter_cbl_learning_path/blob/main/src/lib/inventory_audit_app.dart#L16">InventoryAuditApp</a> that is a Stateless Widget and sets up all repositories and services using <a target="_blank" rel="noopener noreferrer" href="https://github.com/couchbase-examples/flutter_cbl_learning_path/blob/main/src/lib/inventory_audit_app.dart#L47">MultiRepositoryProvider</a>.  The <a target="_blank" rel="noopener noreferrer" href="https://github.com/couchbase-examples/flutter_cbl_learning_path/blob/main/src/lib/features/router/bloc/route_bloc.dart#L10 ">RouteBloc</a> defined is used to handle all routing calls.  This bloc defines a child, <a target="_blank" rel="noopener noreferrer" href="https://github.com/couchbase-examples/flutter_cbl_learning_path/blob/main/src/lib/app_view.dart#L13">AppView</a>, which is a stateful widget that uses a MultiBlocListern to react to changes in the route state and thus render new screens as requested.  

The default state of the app is for the user to not be authenticated, which will call the <a target="_blank" rel="noopener noreferrer" href="https://github.com/couchbase-examples/flutter_cbl_learning_path/blob/main/src/lib/features/login/views/login_screen.dart">LoginScreen</a> widget to render.  LoginScreen uses a <a target="_blank" rel="noopener noreferrer" href="https://pub.dev/documentation/flutter_bloc/latest/flutter_bloc/BlocProvider-class.html">BlocProvider</a> to inject <a target="_blank" rel="noopener noreferrer" href="https://github.com/couchbase-examples/flutter_cbl_learning_path/blob/main/src/lib/features/login/bloc/login_bloc.dart">LoginBloc</a> into the render tree which defines <a target="_blank" rel="noopener noreferrer" href="https://github.com/couchbase-examples/flutter_cbl_learning_path/blob/main/src/lib/features/login/views/login_form.dart#L6">LoginForm</a> as a child to render the UI.  When a user taps the <a target="_blank" rel="noopener noreferrer" href="https://github.com/couchbase-examples/flutter_cbl_learning_path/blob/main/src/lib/features/login/views/login_form.dart#L130">_LoginButton</a>, the <a target="_blank" rel="noopener noreferrer" href="https://github.com/couchbase-examples/flutter_cbl_learning_path/blob/main/src/lib/features/login/bloc/login_event.dart#L28">LoginSubmitted</a> event is added to LoginBloc, which runs the <a target="_blank" rel="noopener noreferrer" href="https://github.com/couchbase-examples/flutter_cbl_learning_path/blob/main/src/lib/features/login/bloc/login_bloc.dart#L47">_onSubmitted</a> method to update state with if the user logged in properly or not.  If the user is authenticated properly the state is updated and the <a target="_blank" rel="noopener noreferrer" href="https://github.com/couchbase-examples/flutter_cbl_learning_path/blob/main/src/lib/app_view.dart#L57">BlocListner for RouteState</a> will push the <a target="_blank" rel="noopener noreferrer" href="https://github.com/couchbase-examples/flutter_cbl_learning_path/blob/main/src/lib/features/project/views/project_list_screen.dart#L12">ProjectListScreen</a>widget to the render tree.  

The user can use the <a target="_blank" rel="noopener noreferrer" href="https://github.com/couchbase-examples/flutter_cbl_learning_path/blob/main/src/lib/features/drawer/views/menu_drawer.dart#L7">menu drawer</a> to navigate to other sections of the app or use the Floating Action button to <a target="_blank" rel="noopener noreferrer" href="https://github.com/couchbase-examples/flutter_cbl_learning_path/blob/main/src/lib/featu">add a new Project</a>.

### Replication

#### Couchbase Capella App Services Users
It's highly recommended to follow the full documentation on the [Couchbase Developer Portal](https://developer.couchbase.com/learn/).  An overview of the steps using the <a target="_blank" rel="noopener noreferrer" href="https://docs.couchbase.com/cloud/mobile-guides/intro.html">Couchbase Capella</a> documentation is provided below:

The steps below will guide you through the following:
 * Setup an App Endpoint under your App Services in Couchbase Capella named `projects` 
 * Update your import and sync functions
 * Create App Roles and App Users
 * Copy the URL of the App Endpoint
 * Download the App Endpoint Public Certificate file
 * Update the app to use the public certficate and URL information to connect to Couchbase Capella App Services to sync documents between the mobile app and App Services.  

1. Create an endpoint called projects using the documentation found  <a target="_blank" rel="noopener noreferrer" href="https://docs.couchbase.com/cloud/app-services/deployment/creating-an-app-endpoint.html">here</a>.
  * **NOTE** Use the <a target="_blank" rel="noopener noreferrer" href="[https://docs.couchbase.com/cloud/app-services/deployment/creating-an-app-endpoint.html](https://github.com/couchbase-examples/flutter_cbl_learning_path/blob/main/capella/import.js">import</a> file in the Import Filter section of the documentation.
2. You will need to update the Access Control and Validation for the App Endpoint usng documentation you can find <a target="_blank" rel="noopener noreferrer" href="https://docs.couchbase.com/cloud/app-services/deployment/access-control-data-validation.html">here</a>.
  * **NOTE** Use the <a target="_blank" rel="noopener noreferrer" href="[https://docs.couchbase.com/cloud/app-services/deployment/creating-an-app-endpoint.html](https://github.com/couchbase-examples/flutter_cbl_learning_path/blob/main/capella/sync.js">sync</a> file in the second step under Security > Access and Validation.
3. You will need to add the roles for the users using the documentation found <a target="_blank" rel="noopener noreferrer" href="https://docs.couchbase.com/cloud/app-services/user-management/create-app-role.html">here</a>.
 * You will need to create roles `team1` through `team15` with the same channel name as the role name.  These are assigned to the user in the <a target="_blank" rel="noopener noreferrer" href="https://github.com/couchbase-examples/flutter_cbl_learning_path/blob/main/src/lib/features/router/service/auth_service.dart#L67">auth_services.dart</a> file and must must match this file or you will get a 403 error when trying to replicate.
4. You will need to create sample users using the documentation found <a target="_blank" rel="noopener noreferrer" href="https://docs.couchbase.com/cloud/app-services/user-management/create-user.html">here</a>.
  * You will need to create users `demo@example.com` through `demo15@example.com` same roles as found in the <a target="_blank" rel="noopener noreferrer" href="https://github.com/couchbase-examples/flutter_cbl_learning_path/blob/main/src/lib/features/router/service/auth_service.dart#L67">auth_services.dart</a> file.  If the user isn't added to the proper role, you will have issues when trying to replicate documents.
5. From the App Services Endpoint section of Couchbase Capella, click on the <a target="_blank" rel="noopener noreferrer" href="https://docs.couchbase.com/cloud/app-services/connect/connect-apps-to-endpoint.html">Connect tab</a>.
6.  You will need to write down the `Public Connection` URL that is provided on this page so we can update the hostname in the `replicator_provider.dart` file in a later step.
7.  Download the Public Certificate file.  The dart SDK doesn't include the App Services certificate, so you will need to provide it in the app and then `pin it` in the replication configuration.  You can click the Download button under Public Certificate which should download a cert.pem file.
8.  Add the .pem file (certificate) to the src folder.  It should be at the same folder structure level as your <a target="_blank" rel="noopener noreferrer" href="https://github.com/couchbase-examples/flutter_cbl_learning_path/blob/main/src/pubspec.yaml">pubspec.yaml</a> file. 
9.  Update the <a target="_blank" rel="noopener noreferrer" href="https://github.com/couchbase-examples/flutter_cbl_learning_path/blob/main/src/pubspec.yaml#L43">src/pubspec.yaml</a> file to include the certificate file.  Note it's YAML so the spacing is important.  An example of what the file file should look like after this change is provided below:
```yaml
  assets:
    - asset/images/couchbase.png
    - asset/database/startingWarehouses.zip
    - cert.pem
```  
10. Open the <a target="_blank" rel="noopener noreferrer" href="https://github.com/couchbase-examples/flutter_cbl_learning_path/blob/main/src/lib/features/database/replicator_provider.dart">replicator_provider.dart</a> file found in the src/lib/features/database directory.
11. Uncomment <a target="_blank" rel="noopener noreferrer" href="https://github.com/couchbase-examples/flutter_cbl_learning_path/blob/main/src/lib/features/database/replicator_provider.dart#L82">line 82</a> that will load the pem file that you added in `step 5` and put in the YAML file in `step 6`
```dart
var pem = await rootBundle.load('cert.pem');
```
12. Update <a target="_blank" rel="noopener noreferrer" href="https://github.com/couchbase-examples/flutter_cbl_learning_path/blob/main/src/lib/features/database/replicator_provider.dart#L87">line 87</a> with the hostname part of your URL that you got from `step 3`.  Note you have to remove the `endpoint` name from the url to get the hostname.  It should look similar to this:
```dart
  var url = Uri(scheme: 'wss',
        port: 4984,
        host: 'your_account_hostname.apps.cloud.couchbase.com',             
        path: 'projects',
      );
```  
13.  Uncomment out <a target="_blank" rel="noopener noreferrer" href="https://github.com/couchbase-examples/flutter_cbl_learning_path/blob/main/src/lib/features/database/replicator_provider.dart#L103">line 103</a> in order to load the PEM file as a pinned certificate.  This will allow the device to trust the connection between App Services and the mobile device.  Your code should look like this when done:
```dart
      _replicatorConfiguration = ReplicatorConfiguration(
          database: db,
          target: endPoint,
          authenticator: basicAuthenticator,
          continuous: true,
          replicatorType: ReplicatorType.pushAndPull,
          heartbeat: const Duration(seconds: 60),
          // **UNCOMMENT** this the line below if you are using App Services or a custom certificate
          pinnedServerCertificate: pem.buffer.asUint8List()
        );
```
14.  Open the <a target="_blank" rel="noopener noreferrer" href="https://github.com/couchbase-examples/flutter_cbl_learning_path/blob/main/src/lib/features/router/bloc/route_bloc.dart#L110">src/lib/features/router/bloc/route_bloc.dart</a> file 
15.  Uncomment out <a target="_blank" rel="noopener noreferrer" href="https://github.com/couchbase-examples/flutter_cbl_learning_path/blob/main/src/lib/features/router/bloc/route_bloc.dart#L110">line 110</a> so it enables the replicator to initalize once the user logs into the app.

```dart
  await _replicatorProvider.init();
```
16.  You should be able to now debug the app and replication should start working.  Any documents found on Couchbase Server will be replicated to the mobile device and any documents created on the mobile device will be replicated to the server.  You can use the Couchbase Server UI to see the documents that are being replicated.

### Try it out

* Open src folder using your favorite IDE
* Build and run the project.
* Log in to the app with  **_"demo@example.com"_** and **_"P@ssw0rd12"_** for user Id and password fields respectively.

## Community Documentation

The Dart and Flutter community documentation can be found <a target="_blank" rel="noopener noreferrer" href="https://cbl-dart.dev/">here</a>.