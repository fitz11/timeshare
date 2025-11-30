// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class ShapeConverter implements JsonConverter<BoxShape, String> {
  const ShapeConverter();

  @override
  BoxShape fromJson(String json) =>
      json == 'circle' ? BoxShape.circle : BoxShape.rectangle;

  @override
  String toJson(BoxShape shape) =>
      shape == BoxShape.circle ? 'circle' : 'rectangle';
}
