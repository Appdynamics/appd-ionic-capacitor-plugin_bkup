package com.appdynamics.appd.mrum.plugins.ionic;

import android.app.Instrumentation;
import android.util.Log;
import com.appdynamics.eumagent.runtime.Instrumentation;
import com.appdynamics.eumagent.runtime.InstrumentationCallbacks;
import com.appdynamics.eumagent.runtime.AgentConfiguration;
import com.appdynamics.eumagent.runtime.CallTracker;
import com.appdynamics.eumagent.runtime.HttpRequestTracker;
import com.appdynamics.eumagent.runtime.SessionFrame;
import com.appdynamics.eumagent.runtime.ServerCorrelationHeaders;
import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Iterator;
import java.net.URL;
import java.net.MalformedURLException;
import android.webkit.WebView;

public class ADEUMMobileCapacitorPlugin {
    private final static String ADEumPluginType = "Ionic Capacitor";
    private final static String VERSION = "1.1.0";
    private final static String TAG = "EUMCapacitorPlgImpl";
    private HashMap<String, CallTracker> callTrackers;
    private HashMap<String, HttpRequestTracker> httpRequestTrackers;
    private HashMap<String, SessionFrame> sessionFrames;
    private boolean pluginInitialized;

    //public void initialize(CordovaInterface cordova, CordovaWebView webView) {
    public void load() {
        //super.initialize(cordova, webView);
        callTrackers = new HashMap<String, CallTracker>();
        httpRequestTrackers = new HashMap<String, HttpRequestTracker>();
        sessionFrames = new HashMap<String, SessionFrame>();

        // Initialize the agent before the Cordova WebView loads the default page

        //int appKeyResId = cordova.getActivity().getResources().getIdentifier("adeum_app_key", "string", cordova.getActivity().getPackageName());
        String appKey = getConfig.getString("adeum_app_key");
        //int collectorUrlResId = cordova.getActivity().getResources().getIdentifier("adeum_collector_url", "string", cordova.getActivity().getPackageName());
        String collectorUrl = getConfig.getString("adeum_collector_url");
        //int screenshotUrlResId = cordova.getActivity().getResources().getIdentifier("adeum_screenshot_url", "string", cordova.getActivity().getPackageName());
        String screenshotUrl = getConfig.getString("adeum_screenshot_url");
        //int screenshotsEnabledResId = cordova.getActivity().getResources().getIdentifier("adeum_screenshots_enabled", "string", cordova.getActivity().getPackageName());
        boolean screenshotsEnabled = false;
        try {
            screenshotsEnabled = Boolean.parseBoolean(getConfig.getString("adeum_screenshots_enabled"));
        } catch (Exception ex) {
        }
        //int loggingLevelResId = cordova.getActivity().getResources().getIdentifier("adeum_logging_level", "string", cordova.getActivity().getPackageName());
        int loggingLevel = 2;
        try {
            loggingLevel = Integer.parseInt(getConfig.getString("adeum_logging_level"));
            switch (loggingLevel) {
                case 6: //verbose
                case 5:
                case 4:
                    loggingLevel = 1;
                    break;
                case 3: //info
                case 2:
                case 1:
                    loggingLevel = 2;
                    break;
            }
        } catch (Exception ex) {
        }
        //int interactionCaptureModeResId = cordova.getActivity().getResources().getIdentifier("adeum_interaction_capture_mode", "string", cordova.getActivity().getPackageName());
        int interactionCaptureMode = 0;
        try {
            interactionCaptureMode = Integer.parseInt(getConfig().getString("adeum_interaction_capture_mode"));
        } catch (Exception ex) {
        }

        AgentConfiguration config = AgentConfiguration.builder().
                withAppKey(appKey).
                withContext(cordova.getActivity()).
                withCollectorURL(collectorUrl).
                withScreenshotURL(screenshotUrl).
                withLoggingLevel(loggingLevel).
                withJSAgentAjaxEnabled(true).
                withScreenshotsEnabled(screenshotsEnabled).
                withInteractionCaptureMode(interactionCaptureMode).
                build();

        // since there is no way to return an error to the host app we keep track of the error
        // in pluginInitialized flag and return it when a method is invoked on the plugin
        try {
            Instrumentation.startFromHybrid(config, ADEumPluginType, VERSION);
            pluginInitialized = true;
        } catch (IllegalArgumentException ex) {
            Log.e(TAG, ex.getMessage());
            pluginInitialized = false;
        }
    }


    public void clear() {
        if (callTrackers != null)
            callTrackers.clear();
        if (httpRequestTrackers != null)
            httpRequestTrackers.clear();
        if (sessionFrames != null)
            sessionFrames.clear();
    }

    public String getVersion() {
        return VERSION;
    }

    private void initWithAppKey(JSONArray args, CallbackContext callbackContext) throws JSONException {
        AgentConfiguration config = AgentConfiguration.builder().withAppKey(args.getString(0)).build();
        Instrumentation.startFromHybrid(config, ADEumPluginType, VERSION);
        callbackContext.success(VERSION);
    }

    private void initWithConfiguration(JSONArray args, CallbackContext callbackContext) throws JSONException {
        JSONObject map = args.getJSONObject(0);
        int loggingLevel = map.getInt("loggingLevel");
        //map from shared values to android agent specific ones
        int loggingLevelAndroid = 3;
        switch (loggingLevel) {
            case 6: //verbose
            case 5:
            case 4:
                loggingLevelAndroid = 1;
                break;
            case 3: //info
            case 2:
            case 1:
                loggingLevelAndroid = 2;
                break;
        }

        AgentConfiguration config = AgentConfiguration.builder().
                withAppKey(map.getString("appKey")).
                withContext(cordova.getActivity()).
                withCollectorURL(map.getString("collectorUrl")).
                withScreenshotURL(map.getString("screenshotUrl")).
                withLoggingLevel(loggingLevelAndroid).
                withJSAgentAjaxEnabled(true).
                withScreenshotsEnabled(map.getBoolean("screenshots")).
                build();

        Instrumentation.startFromHybrid(config, ADEumPluginType, VERSION);
        callbackContext.success(VERSION);
    }

    private void changeAppKey(JSONArray args, CallbackContext callbackContext) throws JSONException {
        Instrumentation.changeAppKey(args.getString(0));
        callbackContext.success(VERSION);
    }

    public void crash() throws RuntimeException {
        throw new RuntimeException("Crash Attempt");
    }

    public void flush() {
        try {
            HttpRequestTracker tracker = Instrumentation.beginHttpRequest(new URL("http://flush.queue"));
            tracker.withResponseCode(200).reportDone();
            //callbackContext.success();
        } catch (MalformedURLException mue) {
        }
    }

    public boolean checkPluginInitialized() {
        return pluginInitialized;
    }


    public String echo(String value) {
        Log.i("Echo", value);
        return value;
    }
    /* Custom method implementation starts here */
    public void stopTimerWithName(String name) {
        Instrumentation.stopTimer(name);
    }

    public void reportMetricWithName(String name, Integer value) {
        Instrumentation.reportMetric(name, value);
    }

    public void leaveBreadcrumb(String name) {
        Instrumentation.leaveBreadcrumb(args.getString(0), Integer.parseInt(args.getString(1)));
    }

    public void setUserData(String key, String value) {
        Instrumentation.setUserData(key, value);
    }

    public void removeUserData(String key) {
        Instrumentation.removeUserData(key);
    }

    public void takeScreenshot() {
        Instrumentation.takeScreenshot();
    }

    public String beginCall(String className, String methodName, JSArray args) {
        CallTracker callTracker = Instrumentation.beginCall(className, methodName, args);
        String uuid = UUID.randomUUID().toString();
        callTrackers.put(uuid, callTracker);
        return uuid;
    }

    public JSObject beginHttpRequest(String url) {
        try {
            HttpRequestTracker tracker = Instrumentation.beginHttpRequest(new URL(url);
            String uuid = UUID.randomUUID().toString();
            httpRequestTrackers.put(uuid, tracker);
            JSObject jsObject = new JSObject();
            jsObject.put("uuid", uuid);
            return jsObject;
        } catch (MalformedURLException me){
            Log.e(TAG, me.getMessage());
        }
    }

    public void reportDone(String trackerId) {
        try{
            HttpRequestTracker tracker = httpRequestTrackers.get(trackerId);
            tracker.reportDone();
        }catch(Exception e){
            Log.e(TAG, "Invalid Tracker Object");
        }
    }

    public void withResponseCode(String trackerId, Integer statusCode) {
        try{
            HttpRequestTracker tracker = httpRequestTrackers.get(trackerId);
            tracker.withResponseCode(statusCode);
        }catch(Exception e){
            Log.e(TAG, "Invalid Tracker Object");
        }
    }

    public void withResponseContentLength(String trackerId, Integer contentLength) {
        try{
            HttpRequestTracker tracker = httpRequestTrackers.get(trackerId);
            tracker.withResponseContentLength(contentLength);
        }catch(Exception e){
            Log.e(TAG, "Invalid Tracker Object");
        }
    }

    public void withRequestContentLength(String trackerId, Integer contentLength) {
        try{
            HttpRequestTracker tracker = httpRequestTrackers.get(trackerId);
            tracker.withResponseContentLength(contentLength);
        }catch(Exception e){
            Log.e(TAG, "Invalid Tracker Object");
        }
    }

    public void withResponseHeaderFields(String trackerId, JSObject httpHeaders) {
        try{
            HttpRequestTracker tracker = httpRequestTrackers.get(trackerId);
            HashMap headersMap = new HashMap();
            Iterator itor = httpHeaders.keys();
            while (itor.hasNext()) {
                String key = (String) itor.next();
                String val = httpHeaders.getString(key);
                ArrayList list = new ArrayList();
                list.add(val);
                // AppD magic headers must be uppercase CORE-39486
                if (key.startsWith("adrum")) {
                    key = key.toUpperCase();
                }
                headersMap.put(key, list);
            }
            tracker.withResponseHeaderFields(headersMap);
        }catch(ClassCastException | NullPointerException e){
            Log.e(TAG, "Invalid Tracker Object");
        }
        catch(Exception e){
            Log.e(TAG, "Internal error occurred setting header fields");
        }
    }

    public void withRequestHeaderFields(String trackerId, JSObject httpHeaders) {
        try{
            HttpRequestTracker tracker = httpRequestTrackers.get(trackerId);
            HashMap headersMap = new HashMap();
            Iterator itor = httpHeaders.keys();
            while (itor.hasNext()) {
                String key = (String) itor.next();
                String val = httpHeaders.getString(key);
                ArrayList list = new ArrayList();
                list.add(val);
                // AppD magic headers must be uppercase CORE-39486
                if (key.startsWith("adrum")) {
                    key = key.toUpperCase();
                }
                headersMap.put(key, list);
            }
            tracker.withRequestHeaderFields(headersMap);
        }catch(ClassCastException | NullPointerException e){
            Log.e(TAG, "Invalid Tracker Object");
        }
        catch(Exception e){
            Log.e(TAG, "Internal error occurred setting header fields");
        }
    }

    public void withErrorMessage(String trackerId, String errorMessage) {
        try{
            HttpRequestTracker tracker = httpRequestTrackers.get(trackerId);
            tracker.withError(errorMessage);
        }catch(Exception e){
            Log.e(TAG, "Invalid Tracker Object");
        }
    }

    public Map<String, List<String>> getCorrelationHeaders() {
        Map<String, List<String>> correlationHeaders = ServerCorrelationHeaders.generate();
        return correlationHeaders;
    }

    public void startNextSession() {
        Instrumentation.startNextSession();
    }

    public void unblockScreenshots() {
        Instrumentation.unblockScreenshots();
    }

    public void blockScreenshots() {
        Instrumentation.blockScreenshots();
    }

    public Boolean screenshotsBlocked() {
        return Instrumentation.screenshotsBlocked();
    }

    public String startSessionFrame(String sessionFrameName) {
        SessionFrame sessionFrame = Instrumentation.startSessionFrame(sessionFrameName);
        String uuid = UUID.randomUUID().toString();
        sessionFrames.put(uuid, sessionFrame);
        return uuid;
    }

    public void endSessionFrame(String sessionFrameName) {
        try{
            SessionFrame sessionFrame = sessionFrames.get(sessionFrameName);
            sessionFrame.end();
            sessionFrames.remove(sessionFrameName);
        }catch(Exception e){
            Log.e(TAG, "Invalid Tracker Object");
        }
    }

    public void updateSessionFrame(String tracker, String sessionFrameName) {

    }

    public void endCall(JSObject callTrackerId) {
        CallTracker callTracker = callTrackers.get(callTrackerId);
        callTracker.reportCallEnded();
        callTrackers.remove(callTrackerId);
    }

    public void startTimeWithName(String name) {
        Instrumentation.startTimer(name);
    }
}
