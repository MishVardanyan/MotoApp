package com.example.flutter_yandex_mapkit_example

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.yandex.mapkit.MapKitFactory

class MainActivity: FlutterActivity() {
  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    MapKitFactory.setApiKey("e0731b5b-9961-4cdb-bc01-8bcd8ecb8906") 
    super.configureFlutterEngine(flutterEngine)
  }
}