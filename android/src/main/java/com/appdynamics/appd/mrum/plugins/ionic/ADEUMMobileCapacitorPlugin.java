package com.appdynamics.appd.mrum.plugins.ionic;

import android.util.Log;

import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

import java.net.URL;

@CapacitorPlugin(name = "ADEUMMobileCapacitorPlugin")
public class ADEUMMobileCapacitorPlugin extends Plugin {
    private ADEUMMobileCapacitorPluginImpl implementation = new ADEUMMobileCapacitorPluginImpl();
    private static final String PLACEHOLDER_METRIC = "Generic Metric";
    private static final String PLACEHOLDER_KEY = "Generic Key";
    private static final String PLACEHOLDER_VALUE = "Generic Value";
    private static final String TAG = "ADEUMCapacitorPlugin";

    @PluginMethod
    public void echo(PluginCall call) {
        String value = call.getString("value");
        JSObject ret = new JSObject();
        ret.put("value", implementation.echo(value));
        call.resolve(ret);
    }

    @PluginMethod(returnType = PluginMethod.RETURN_NONE)
    public void startTimerWithName(PluginCall call) {
        String name = call.getString("name");
        Log.d(TAG, " startTimerWithName: " + name);
        call.resolve();
    }

    @PluginMethod(returnType = PluginMethod.RETURN_NONE)
    public void stopTimerWithName(PluginCall call) {
        String name = call.getString("name");
        name = name.replaceAll("\\s","").length()==0 ? PLACEHOLDER_METRIC : name;
        Log.d(TAG, " stopTimerWithName: " + name);
        implementation.stopTimerWithName(name);
        call.resolve();
    }

    @PluginMethod(returnType = PluginMethod.RETURN_NONE)
    public void reportMetricWithName(PluginCall call) {
        String name = call.getString("name");
        name = name.replaceAll("\\s","").length()==0 ? PLACEHOLDER_METRIC : name;
        Log.d(TAG, " reportMetricWithName: " + name);
        Integer value = call.getInt("value");
        implementation.reportMetricWithName(name, value);
        call.resolve();
    }

    @PluginMethod
    public void leaveBreadcrumb(PluginCall call) {
        String name = call.getString("name");
        name = name.replaceAll("\\s","").length()==0 ? PLACEHOLDER_METRIC : name;
        Log.d(TAG, " leaveBreadcrumb: " + name);
        implementation.leaveBreadcrumb(name);
        call.resolve();
    }

    @PluginMethod
    public void setUserData(PluginCall call) {
        String key = call.getString("key");
        key = key.replaceAll("\\s","").length()==0 ? PLACEHOLDER_METRIC : key;
        String value = call.getString("value");
        value = value.replaceAll("\\s","").length()==0 ? PLACEHOLDER_METRIC : value;
        Log.d(TAG, " setUserData: " + key + ", " +value);
        if (!key.equals(PLACEHOLDER_KEY)) {
            implementation.setUserData(key, value);
        }
        call.resolve();
    }

    @PluginMethod
    public void removeUserData(PluginCall call){
        String key = call.getString("key");
        key = key.replaceAll("\\s","").length()==0 ? PLACEHOLDER_METRIC : key;
        Log.d(TAG, " removeUserData: " + key);
        if (!key.equals(PLACEHOLDER_KEY)) {
            implementation.removeUserData(key);
        }
        call.resolve();
    }

    @PluginMethod
    public void takeScreenshot(PluginCall call){
        implementation.takeScreenshot();
        call.resolve();
    }

    @PluginMethod
    public void beginCall(PluginCall call){
        String className = call.getString("className");
        String methodName = call.getString("methodName");
        JSArray args = call.getArray("withArguments");
        Log.d(TAG, " beginCall: " + className + methodName + args);
        if (className.replaceAll("\\s","").length()!=0 && methodName.replaceAll("\\s","").length()!=0){
            JSObject jsonObject = new JSObject();
            jsonObject.put("call_tracker", implementation.beginCall(className,methodName,args));
            call.resolve(jsonObject);
        }else{
            call.resolve();
        }
    }

    @PluginMethod
    public void endCall(PluginCall call){
        JSObject callTracker = call.getObject("call_tracker");
        if (callTracker != null) {
            implementation.endCall(callTracker);
        }
        call.resolve();
    }

    @PluginMethod
    public void beginHTTPRequest(PluginCall call){
        String url = call.getString("url");
        url = url.replaceAll("\\s","").length()==0 ? "" : url;
        Log.d(TAG, " beginHTTPRequest: " + url);
        if (url.length() > 0){
            JSObject http_tracker = implementation.beginHttpRequest(url);
            call.resolve(http_tracker);
        }else{
            call.resolve();
        }
    }

    @PluginMethod
    public void withURL(PluginCall call){
        //unimplemented due to ambiguity
    }

    @PluginMethod
    public void reportDone(PluginCall call){
        String tracker = call.getString("http_tracker");
        tracker = tracker.replaceAll("\\s","").length()==0 ? "" : tracker;
        Log.d(TAG, " reportDone: " + tracker);
        if (tracker.length() > 0){
            implementation.reportDone();
        }
        call.resolve();
    }

    @PluginMethod
    public void withResponseCode(PluginCall call){
        String tracker = call.getString("http_tracker");
        Integer statusCode = call.getInt("status_code");
        Log.d(TAG, " withResponseCode: " + tracker + ", " + statusCode);
        if (tracker.replaceAll("\\s","").length() > 0){
            implementation.withResponseCode(tracker, statusCode);
        }
        call.resolve();
    }

    @PluginMethod
    public void withResponseContentLength(PluginCall call){
        String tracker = call.getString("http_tracker");
        Integer contentLength = call.getInt("content_length");
        Log.d(TAG, " withResponseContentLength: " + tracker + ", " + contentLength);
        if (tracker.replaceAll("\\s","").length() > 0){
            implementation.withResponseContentLength(tracker, contentLength);
        }
        call.resolve();
    }

    @PluginMethod
    public void withRequestContentLength(PluginCall call){
        String tracker = call.getString("http_tracker");
        Integer contentLength = call.getInt("content_length");
        Log.d(TAG, " withResponseContentLength: " + tracker + ", " + contentLength);
        if (tracker.replaceAll("\\s","").length() > 0){
            implementation.withRequestContentLength(tracker, contentLength);
        }
        call.resolve();
    }

    @PluginMethod
    public void withResponseHeaderFields(PluginCall call){
        String tracker = call.getString("http_tracker");
        JSObject httpHeaders =  call.getObject("http_headers");
        if (tracker.replaceAll("\\s","").length() > 0){
            implementation.withResponseHeaderFields(tracker, httpHeaders);
        }
        call.resolve();
    }

    @PluginMethod
    public void withRequestHeaderFields(PluginCall call){
        String tracker = call.getString("http_tracker");
        JSObject httpHeaders =  call.getObject("http_headers");
        if (tracker.replaceAll("\\s","").length() > 0){
            implementation.withResponseHeaderFields(tracker, httpHeaders);
        }
        call.resolve();
    }

    @PluginMethod
    public void withErrorMessage(PluginCall call){
        String tracker = call.getString("http_tracker");
        String errorMessage = call.getString("error_message");
        if (tracker.replaceAll("\\s","").length() > 0){
            implementation.withErrorMessage(tracker, errorMessage);
        }
        call.resolve();
    }

    @PluginMethod
    public void getCorrelationHeaders(PluginCall call){
       JSObject correlationHeaders =  new JSObject();
       correlationHeaders.put("headers", implementation.getCorrelationHeaders());
       call.resolve(correlationHeaders);
    }

    @PluginMethod
    public void startNextSession(PluginCall call){
        implementation.startNextSession();
        call.resolve();
    }

    @PluginMethod
    public void unblockScreenshots(PluginCall call){
        implementation.unblockScreenshots();
        call.resolve();
    }

    @PluginMethod
    public void blockScreenshots(PluginCall call){
        implementation.blockScreenshots();
        call.resolve();
    }

    @PluginMethod
    public void screenshotsBlocked(PluginCall call){
        Boolean isBlocked = implementation.screenshotsBlocked();
        JSObject object = new JSObject();
        object.put("screenshots_blocked", isBlocked);
        call.resolve(object);
    }

    @PluginMethod
    public void startSessionFrame(PluginCall call){
        String sessionFrameName = call.getString("session_frame_name");
        if (sessionFrameName.replaceAll("\\s","").length() > 0){
            JSObject callObject = new JSObject();
            callObject.put("session_frame",  implementation.startSessionFrame(sessionFrameName));
            call.resolve(callObject);
        }else{
            call.resolve();
        }
    }

    @PluginMethod
    public void endSessionFrame(PluginCall call){
        String sessionFrame = call.getString("session_frame");
        if (sessionFrame.replaceAll("\\s","").length() > 0){
            implementation.endSessionFrame(sessionFrame);
        }
        call.resolve();
    }

    @PluginMethod
    public void updateSessionFrame(PluginCall call){
        String sessionFrameName = call.getString("session_frame_name");
        String tracker = call.getString("session_frame");
        if (sessionFrameName.replaceAll("\\s","").length() > 0
                && tracker.replaceAll("\\s","").length() > 0) {
            implementation.updateSessionFrame(tracker, sessionFrameName);
            JSObject object = new JSObject();
            object.put("session_frame", tracker);
            call.resolve(object);
        }else{
            call.resolve();
        }
    }



    @PluginMethod(returnType = PluginMethod.RETURN_NONE)
    public void clear(PluginCall call) {
        implementation.clear();
    }

    @PluginMethod
    public void checkPluginInitialized(PluginCall call) {
        boolean is_initialized = false;
        is_initialized = implementation.checkPluginInitialized();
        //JSObject ret = new JSObject();
        if (!is_initialized) {
            //this may be bad and should just return true or false or reject and resolve
            call.reject("Plugin was not initialized due to missing or invalid App Key.");
            return;
        } else {
            //ret.put("initialized", is_initialized);
            //call.resolve(ret);
            call.resolve();
        }
    }


    @PluginMethod
    public void crash(PluginCall call) {
        JSObject ret = new JSObject();
        try {
            implementation.crash();
        } catch (RuntimeException re) {
            ret.put("exception_type_name", re.getClass().getCanonicalName());
            ret.put("exception_message", re.getMessage());
            call.resolve(ret);
        }

    }
}
