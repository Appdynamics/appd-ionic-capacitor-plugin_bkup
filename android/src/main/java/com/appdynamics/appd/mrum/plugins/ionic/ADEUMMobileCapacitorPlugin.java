package com.appdynamics.appd.mrum.plugins.ionic;

import android.util.Log;
//import com.appdynamics.eumagent.runtime.Instrumentation;
import com.appdynamics.eumagent.runtime.AgentConfiguration;
import com.appdynamics.eumagent.runtime.CallTracker;
import com.appdynamics.eumagent.runtime.HttpRequestTracker;
import com.appdynamics.eumagent.runtime.SessionFrame;
import com.appdynamics.eumagent.runtime.ServerCorrelationHeaders;
import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;


import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Iterator;
import java.net.URL;
import java.net.MalformedURLException;

public class ADEUMMobileCapacitorPlugin {
    private final static String ADEumPluginType = "Ionic Capacitor";
    private final static String VERSION = "1.1.0";
    private final static String TAG = "ADEUMCapacitorPlgImpl";
    private HashMap<String, CallTracker> callTrackers = new HashMap<>();
    private HashMap<String, HttpRequestTracker> httpRequestTrackers = new HashMap<>();
    private HashMap<String, SessionFrame> sessionFrames = new HashMap<>();
    public boolean pluginInitialized;

    public ADEUMMobileCapacitorPlugin() {
    }



    public void crash() throws RuntimeException {
        throw new RuntimeException("Crash Attempt");
    }

    public void flush() {
        try {
            HttpRequestTracker tracker = com.appdynamics.eumagent.runtime.Instrumentation.beginHttpRequest(new URL("http://flush.queue"));
            tracker.withResponseCode(200).reportDone();
            //callbackContext.success();
        } catch (MalformedURLException mue) {
        }
    }

    public boolean checkPluginInitialized() {
        return pluginInitialized;
    }

    /* Custom method implementation starts here */
    public String echo(String value) {
        Log.i("Echo", value);
        return value;
    }

    public void pluginInitialize(AgentConfiguration config){
        com.appdynamics.eumagent.runtime.Instrumentation.start(config);
        pluginInitialized = true;
    }

    public void startTimerWithName(String name) {
        com.appdynamics.eumagent.runtime.Instrumentation.startTimer(name);
    }


    public void stopTimerWithName(String name) {
        com.appdynamics.eumagent.runtime.Instrumentation.stopTimer(name);
    }

    public void reportMetricWithName(String name, Integer value) {
        com.appdynamics.eumagent.runtime.Instrumentation.reportMetric(name, value);
    }

    public void leaveBreadcrumb(String name) {
        com.appdynamics.eumagent.runtime.Instrumentation.leaveBreadcrumb(name);
    }

    public void setUserData(String key, String value) {
        com.appdynamics.eumagent.runtime.Instrumentation.setUserData(key, value);
    }

    public void removeUserData(String key) {
        //function is missing from sdk
        //com.appdynamics.eumagent.runtime.Instrumentation.removeUserData(key);
    }

    public void takeScreenshot() {
        com.appdynamics.eumagent.runtime.Instrumentation.takeScreenshot();
    }

    public String beginCall(String className, String methodName, JSArray args) {
        CallTracker callTracker = com.appdynamics.eumagent.runtime.Instrumentation.beginCall(className, methodName, args);
        String uuid = UUID.randomUUID().toString();
        callTrackers.put(uuid, callTracker);
        return uuid;
    }

    public void endCall(JSObject callTrackerId) {
        CallTracker callTracker = callTrackers.get(callTrackerId);
        callTracker.reportCallEnded();
        callTrackers.remove(callTrackerId);
    }

    public String beginHttpRequest(String url) {
        String uuid = UUID.randomUUID().toString();
        try {
            HttpRequestTracker tracker = com.appdynamics.eumagent.runtime.Instrumentation.beginHttpRequest(new URL(url));
            httpRequestTrackers.put(uuid, tracker);
        } catch (MalformedURLException me){
            Log.e(TAG, me.getMessage());
        }
        return uuid;
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

    public void withResponseContentLength(String trackerId, long contentLength) {
        try{
            HttpRequestTracker tracker = httpRequestTrackers.get(trackerId);
            tracker.withResponseContentLength(contentLength);
        }catch(Exception e){
            Log.e(TAG, "Invalid Tracker Object");
        }
    }

    public void withRequestContentLength(String trackerId, long contentLength) {
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

    public void withInstrumentationSource(String trackerId, String information_source) {
        try{
            HttpRequestTracker tracker = httpRequestTrackers.get(trackerId);
            tracker.withInstrumentationSource(information_source);
        }catch(Exception e){
            Log.e(TAG, "Invalid Tracker Object");
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
        com.appdynamics.eumagent.runtime.Instrumentation.startNextSession();
    }

    public void unblockScreenshots() {
        com.appdynamics.eumagent.runtime.Instrumentation.unblockScreenshots();
    }

    public void blockScreenshots() {
        com.appdynamics.eumagent.runtime.Instrumentation.blockScreenshots();
    }

    public Boolean screenshotsBlocked() {
        return com.appdynamics.eumagent.runtime.Instrumentation.screenshotsBlocked();
    }

    public String startSessionFrame(String sessionFrameName) {
        SessionFrame sessionFrame = com.appdynamics.eumagent.runtime.Instrumentation.startSessionFrame(sessionFrameName);
        String uuid = UUID.randomUUID().toString();
        sessionFrames.put(uuid, sessionFrame);
        return uuid;
    }

    public void endSessionFrame(String session_key) {
        try{
            SessionFrame sessionFrame = sessionFrames.get(session_key);
            sessionFrame.end();
            sessionFrames.remove(session_key);
        }catch(Exception e){
            Log.e(TAG, "Invalid Tracker Object");
        }
    }

    public void updateSessionFrame(String session_key, String sessionFrameName) {
        try{
            SessionFrame sessionFrame = sessionFrames.get(session_key);
            sessionFrame.updateName(sessionFrameName);
            sessionFrames.put(session_key, sessionFrame);
        }catch(Exception e){
            Log.e(TAG, "Invalid Tracker Object");
        }
    }

    public String getVersion() {
        return VERSION;
    }

    public void clear() {
        if (callTrackers != null)
            callTrackers.clear();
        if (httpRequestTrackers != null)
            httpRequestTrackers.clear();
        if (sessionFrames != null)
            sessionFrames.clear();
    }




}
