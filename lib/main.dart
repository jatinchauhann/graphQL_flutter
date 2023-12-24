import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(const MaterialApp(
    title: 'GraphQL App',
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink("https://countries.trevorblades.com/");

    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
        GraphQLClient(link: httpLink, cache: GraphQLCache()));
    return GraphQLProvider(
      child: HomePage(),
      client: client,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GraphQL Client'),
      ),
      body: Query(
        options: QueryOptions(
            document: gql(
              r"""
                    query GetContinent($code:ID!){
                    continent(code:$code){
                      countries {
                        name
                      }
                    }
                  }
        """,
            ),
            variables: const <String, dynamic>{"code": "AS"}),
        builder: (QueryResult result, {fetchMore, refetch}) {
          if (result.data == null) {
            return const Text("No Data Found");
          }

          return ListView.builder(
              itemCount: result.data!['continent']['countries'].length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    title: Text(
                        result.data!['continent']['countries'][index]['name']));
              });
        },
      ),
    );
  }
}
