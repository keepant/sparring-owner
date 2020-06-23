import 'package:flutter/material.dart';
import "package:graphql_flutter/graphql_flutter.dart";
import 'package:sparring_owner/services/prefs.dart';

class API {
  static final HttpLink httpLink = HttpLink(
    uri: 'https://sparring-api.herokuapp.com/v1/graphql',
  );

  static final WebSocketLink websocketLink = WebSocketLink(
    url: 'wss://https://sparring-api.herokuapp.com/v1/graphql',
    config: SocketClientConfig(
      autoReconnect: true,
      inactivityTimeout: Duration(seconds: 30),
    ),
  );

  static final AuthLink authLink = AuthLink(
    getToken: () async => 'Bearer ' + await prefs.getToken(),
  );

  static final Link link = authLink.concat(httpLink).concat(websocketLink);

  static ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
      link: link,
    ),
  );

  static ValueNotifier<GraphQLClient> guestClient = ValueNotifier(
    GraphQLClient(
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
      link: httpLink,
    ),
  );
}
