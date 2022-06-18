package com.example.text_process;
import androidx.annotation.NonNull;

import java.util.Map;

import io.flutter.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MethodCallHandlerImplementation implements MethodChannel.MethodCallHandler {

    private static final String TAG = TextProcessPlugin.getPluginTag();

    public MethodCallHandlerImplementation() {}

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if (call.method.equals("initialize")) {
            Map<String, String> arguments = call.arguments();
            // Setting User Initialization coming from flutter side
            assert arguments != null;
            TextProcessPlugin.setUserInitialization(
                    Boolean.parseBoolean(arguments.get("showConfirmationToast")),
                    Boolean.parseBoolean(arguments.get("showRefreshToast")),
                    Boolean.parseBoolean(arguments.get("showErrorToast")),
                    arguments.get("confirmationMessage"),
                    arguments.get("refreshMessage"),
                    arguments.get("errorMessage"));
        } else if (call.method.equals("getRefreshProcessText")) {
            try {
                String textIntent = TextProcessPlugin.getSavedProcessIntentText();
                result.success(textIntent);
                TextProcessPlugin.setSavedProcessIntentText(null);
                TextProcessPlugin.showRefreshToast();
            } catch (Exception error) {
                TextProcessPlugin.showErrorToast();
                Log.e(TAG, "Method Call Failed");
                Log.i(TAG, "Make sure you are calling the correct method.");
            }
        } else {
            result.notImplemented();
        }
    }
}
