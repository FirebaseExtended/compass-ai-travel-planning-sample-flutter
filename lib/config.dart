enum Env { prod, dev }

Env environment = Env.dev;

String get backendEndpoint {
  return switch (environment) {
    Env.prod => 'tripedia-genkit-exp-hovwuqnpzq-uc.a.run.app',
    Env.dev =>
      const String.fromEnvironment('WEB_HOST', defaultValue: "localhost:6789")
    // '9000-idx-tripedia-flutter-1720557953594.cluster-t23zgfo255e32uuvburngnfnn4.cloudworkstations.dev'
  };
}
