// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/// Model class for Destination data
class Destination {
  Destination({
    required this.ref,
    required this.name,
    required this.country,
    required this.continent,
    required this.knownFor,
    required this.tags,
    required this.imageUrl,
  });

  /// e.g. 'alaska'
  final String ref;

  /// e.g. 'Alaska'
  final String name;

  /// e.g. 'United States'
  final String country;

  /// e.g. 'North America'
  final String continent;

  /// e.g. 'Alaska is a haven for outdoor enthusiasts ...'
  final String knownFor;

  /// e.g. ['Mountain', 'Off-the-beaten-path', 'Wildlife watching']
  final List<String> tags;

  /// e.g. 'https://storage.googleapis.com/tripedia-images/destinations/alaska.jpg'
  final String imageUrl;

  @override
  String toString() {
    return 'Destination{ref: $ref, name: $name, country: $country, continent: $continent, knownFor: $knownFor, tags: $tags, imageUrl: $imageUrl}';
  }

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      ref: json['ref'] as String,
      name: json['name'] as String,
      country: json['country'] as String,
      continent: json['continent'] as String,
      knownFor: json['knownFor'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      imageUrl: json['imageUrl'] as String,
    );
  }
}
