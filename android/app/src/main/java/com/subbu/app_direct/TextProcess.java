package com.subbu.app_direct;

import com.example.text_process.TextProcessPlugin;
import io.flutter.embedding.android.FlutterActivity;
import android.os.Bundle;
// finding that the app is running or not

public class TextProcess extends FlutterActivity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        boolean isAppRunning = MainActivity.getIsAppRunning();
        TextProcessPlugin.listenProcessTextIntent(isAppRunning);
    }
}

