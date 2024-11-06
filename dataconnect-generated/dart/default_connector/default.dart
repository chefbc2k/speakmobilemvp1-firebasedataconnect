library default_connector;

import 'dart:convert';

// Define the connector configuration class
class ConnectorConfig {
  final String region;
  final String environment;
  final String projectId;

  ConnectorConfig(this.region, this.environment, this.projectId);
}

// Define the CallerSDKType enum
enum CallerSDKType {
  generated,
  custom
}

// Define the FirebaseDataConnect class
class FirebaseDataConnect {
  final ConnectorConfig connectorConfig;
  final CallerSDKType sdkType;

  FirebaseDataConnect({
    required this.connectorConfig,
    required this.sdkType,
  });

  static FirebaseDataConnect instanceFor({
    required ConnectorConfig connectorConfig,
    required CallerSDKType sdkType,
  }) {
    return FirebaseDataConnect(
      connectorConfig: connectorConfig,
      sdkType: sdkType,
    );
  }
}

class DefaultConnector {
  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-central1',
    'default',
    'speakmobilemvp2',
  );

  DefaultConnector({required this.dataConnect});

  static DefaultConnector get instance {
    return DefaultConnector(
      dataConnect: FirebaseDataConnect.instanceFor(
        connectorConfig: connectorConfig,
        sdkType: CallerSDKType.generated,
      ),
    );
  }

  final FirebaseDataConnect dataConnect;
}

