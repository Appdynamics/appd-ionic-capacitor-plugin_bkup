package com.appdynamics.appd.mrum.plugins.ionic;

import android.util.Log;
import com.appdynamics.eumagent.runtime.Instrumentation;
import com.appdynamics.eumagent.runtime.InstrumentationCallbacks;
import com.appdynamics.eumagent.runtime.AgentConfiguration;
import com.appdynamics.eumagent.runtime.CallTracker;
import com.appdynamics.eumagent.runtime.HttpRequestTracker;
import com.appdynamics.eumagent.runtime.SessionFrame;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
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
    private HashMap<String, CallTracker> callTrackers;
    private HashMap<String, HttpRequestTracker> httpRequestTrackers;
    private HashMap<String, SessionFrame> sessionFrames;
    private boolean pluginInitialized;

    //public void initialize(CordovaInterface cordova, CordovaWebView webView) {
    public void load(){
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
        } catch (Exception ex) { }
        //int loggingLevelResId = cordova.getActivity().getResources().getIdentifier("adeum_logging_level", "string", cordova.getActivity().getPackageName());
        int loggingLevel = 2;
        try {
           loggingLevel = Integer.parseInt(getConfig.getString("adeum_logging_level"));
           switch(loggingLevel)
           {
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
        } catch (Exception ex) { }
        //int interactionCaptureModeResId = cordova.getActivity().getResources().getIdentifier("adeum_interaction_capture_mode", "string", cordova.getActivity().getPackageName());
        int interactionCaptureMode = 0;
        try {
           interactionCaptureMode = Integer.parseInt(getConfig().getString("adeum_interaction_capture_mode"));
        } catch (Exception ex) { }

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
           pluginInitialized = false;
        }
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (!checkPluginInitialized(callbackContext))
           return false;
        // this try will ensure the host app never crashes if there's an error in execution
        // of the plugin or the native agent
        try {
           if ("getVersion".equals(action)) {
               this.getVersion( callbackContext);
               return true;
           } else if ("initWithConfiguration".equals(action)) {
               JSONObject map = args.getJSONObject(0);
               this.initWithConfiguration( args, callbackContext);
               return true;
           } else if ("changeAppKey".equals(action)) {
               this.changeAppKey( args, callbackContext);
               return true;
           } else if ("startTimerWithName".equals(action)) {
               this.startTimerWithName( args, callbackContext);
               return true;
           } else if ("stopTimerWithName".equals(action)) {
               this.stopTimerWithName( args, callbackContext);
               return true;
           } else if ("reportMetricWithName".equals(action)) {
               this.reportMetricWithName( args, callbackContext);
               return true;
           } else if ("leaveBreadcrumb".equals(action)) {
               this.leaveBreadcrumb( args, callbackContext);
               return true;
           } else if ("setUserData".equals(action)) {
               this.setUserData( args, callbackContext);
               return true;
           } else if ("removeUserData".equals(action)) {
               this.removeUserData( args, callbackContext);
               return true;
           } else if ("takeScreenshot".equals(action)) {
               this.takeScreenshot( args, callbackContext);
               return true;
           } else if ("beginCall".equals(action)) {
               this.beginCall( args, callbackContext);
               return true;
           } else if ("endCall".equals(action)) {
               this.endCall( args, callbackContext);
               return true;
           } else if ("beginHttpRequest".equals(action)) {
               this.beginHttpRequest( args, callbackContext);
               return true;
           } else if ("withURL".equals(action)) {
               this.withURL( args, callbackContext);
               return true;
           } else if ("withResponseCode".equals(action)) {
               this.withResponseCode( args, callbackContext);
               return true;
           } else if ("withResponseContentLength".equals(action)) {
               this.withResponseContentLength( args, callbackContext);
               return true;
           } else if ("withRequestContentLength".equals(action)) {
               this.withRequestContentLength( args, callbackContext);
               return true;
           } else if ("withErrorMessage".equals(action)) {
               this.withErrorMessage( args, callbackContext);
               return true;
           } else if ("withRequestHeaderFields".equals(action)) {
               this.withRequestHeaderFields( args, callbackContext);
               return true;
           } else if ("withResponseHeaderFields".equals(action)) {
               this.withResponseHeaderFields( args, callbackContext);
               return true;
           } else if ("withInstrumentationSource".equals(action)) {
               this.withInstrumentationSource( args, callbackContext);
               return true;
           } else if ("reportDone".equals(action)) {
               this.reportDone( args, callbackContext);
               return true;
           } else if ("crash".equals(action)) {
               this.crash( args, callbackContext);
               return true;
           } else if ("flush".equals(action)) {
               this.flush( args, callbackContext);
               return true;
           } else if ("startNextSession".equals(action)) {
               this.startNextSession( args, callbackContext);
               return true;
           } else if ("unblockScreenshots".equals(action)) {
               this.unblockScreenshots( args, callbackContext);
               return true;
           } else if ("blockScreenshots".equals(action)) {
               this.blockScreenshots( args, callbackContext);
               return true;
           } else if ("screenshotsBlocked".equals(action)) {
               this.screenshotsBlocked( args, callbackContext);
               return true;
           } else if ("startSessionFrame".equals(action)) {
               this.startSessionFrame( args, callbackContext);
               return true;
           } else if ("updateSessionFrameName".equals(action)) {
               this.updateSessionFrameName( args, callbackContext);
               return true;
           } else if ("endSessionFrame".equals(action)) {
               this.endSessionFrame( args, callbackContext);
               return true;
           }
        } catch (Exception ex) { callbackContext.error(ex.getMessage()); }

        return false;
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

    private void initWithAppKey(JSONArray args, CallbackContext callbackContext) throws JSONException{
        AgentConfiguration config = AgentConfiguration.builder().withAppKey(args.getString(0)).build();
        Instrumentation.startFromHybrid(config, ADEumPluginType, VERSION);
        callbackContext.success(VERSION);
    }

    private void initWithConfiguration(JSONArray args, CallbackContext callbackContext) throws JSONException{
        JSONObject map = args.getJSONObject(0);
        int loggingLevel = map.getInt("loggingLevel");
        //map from shared values to android agent specific ones
        int loggingLevelAndroid = 3;
        switch(loggingLevel)
        {
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

    private void startTimerWithName(JSONArray args, CallbackContext callbackContext)  throws JSONException {
        Instrumentation.startTimer(args.getString(0));
        callbackContext.success(VERSION);
    }

    private void stopTimerWithName(JSONArray args, CallbackContext callbackContext) throws JSONException {
        Instrumentation.stopTimer(args.getString(0));
        callbackContext.success(VERSION);
    }

    private void reportMetricWithName(JSONArray args, CallbackContext callbackContext) throws JSONException {
        try {
            Instrumentation.reportMetric(args.getString(0), Long.parseLong(args.getString(1)));
            callbackContext.success(VERSION);
        } catch(NumberFormatException ex) {
            callbackContext.error("Metric value must be an integer.");
        }
        callbackContext.success(VERSION);
    }

    private void leaveBreadcrumb(JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (args.length() > 1) {
            try {
               Instrumentation.leaveBreadcrumb(args.getString(0), Integer.parseInt(args.getString(1)));
            } catch(NumberFormatException ex) {
                callbackContext.error("Mode value must be an integer - 0 for crashes only or 1 for crashes and sessions.");
            }
        } else {
            Instrumentation.leaveBreadcrumb(args.getString(0));
        }
        callbackContext.success(VERSION);
    }

    private void setUserData(JSONArray args, CallbackContext callbackContext) throws JSONException {
        Instrumentation.setUserData(args.getString(0), args.getString(1));
        callbackContext.success(VERSION);
    }

    private void removeUserData(JSONArray args, CallbackContext callbackContext) throws JSONException {
        Instrumentation.setUserData(args.getString(0), null);
        callbackContext.success();
    }

    private void takeScreenshot(JSONArray args, CallbackContext callbackContext) throws JSONException {
        Instrumentation.takeScreenshot();
        callbackContext.success();
    }

    private void beginCall(JSONArray args, CallbackContext callbackContext) throws JSONException {
        CallTracker tracker = Instrumentation.beginCall(args.getString(0), args.getString(1), args.getString(2));
        String uuid = UUID.randomUUID().toString();
        callTrackers.put(uuid, tracker);
        callbackContext.success(uuid);
    }

    private void endCall(JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (args.length() > 1) {
            CallTracker tracker = callTrackers.get(args.getString(0));
            if(tracker != null) {
              tracker.reportCallEndedWithReturnValue(args.getString(1));
              callTrackers.remove(args.getString(0));
              callbackContext.success();
            } else
               callbackContext.error("CallTracker object has already been destroyed.");
        }
        else if (args.length() > 0) {
            CallTracker tracker = callTrackers.get(args.getString(0));
            if (tracker != null) {
               tracker.reportCallEnded();
               callTrackers.remove(args.getString(0));
               callbackContext.success();
            } else
               callbackContext.error("CallTracker object has already been destroyed.");
        }
     }

     private void beginHttpRequest(JSONArray args, CallbackContext callbackContext) throws JSONException {
        try {
           HttpRequestTracker tracker = Instrumentation.beginHttpRequest(new URL(args.getString(0)));
           String uuid = UUID.randomUUID().toString();
           httpRequestTrackers.put(uuid, tracker);
           callbackContext.success(uuid);
        } catch (MalformedURLException me) { callbackContext.error("URL argument is not valid."); }
     }

     private void withURL(JSONArray args, CallbackContext callbackContext) throws JSONException {
         if (args.length() > 1) {
             HttpRequestTracker tracker = httpRequestTrackers.get(args.getString(0));
             if (tracker != null) {
                try {
                    tracker.withURL(new URL(args.getString(1)));
                } catch (MalformedURLException me) { callbackContext.error("URL argument is not valid."); }
             } else
                callbackContext.error("Invalid tracker object.");
         } else
            callbackContext.error("URL argument missing.");
    }

    private void withErrorMessage(JSONArray args, CallbackContext callbackContext) throws JSONException {
      if (args.length() > 1) {
          HttpRequestTracker tracker = httpRequestTrackers.get(args.getString(0));
          if (tracker != null) {
            tracker.withError(args.getString(1));
          } else
             callbackContext.error("Invalid tracker object.");
      } else
         callbackContext.error("URL argument missing.");
    }

    private void withResponseCode(JSONArray args, CallbackContext callbackContext) throws JSONException {
      if (args.length() > 1) {
          HttpRequestTracker tracker = httpRequestTrackers.get(args.getString(0));
          if (tracker != null) {
            tracker.withResponseCode(args.getInt(1));
          } else
             callbackContext.error("Invalid tracker object.");
      } else
         callbackContext.error("URL argument missing.");
    }

    private void withRequestContentLength(JSONArray args, CallbackContext callbackContext) throws JSONException {
      if (args.length() > 1) {
          HttpRequestTracker tracker = httpRequestTrackers.get(args.getString(0));
          if (tracker != null) {
            tracker.withRequestContentLength(args.getLong(1));
          } else
             callbackContext.error("Invalid tracker object.");
      } else
         callbackContext.error("URL argument missing.");
    }

    private void withResponseContentLength(JSONArray args, CallbackContext callbackContext) throws JSONException {
      if (args.length() > 1) {
          HttpRequestTracker tracker = httpRequestTrackers.get(args.getString(0));
          if (tracker != null) {
            tracker.withResponseContentLength(args.getLong(1));
          } else
             callbackContext.error("Invalid tracker object.");
      } else
         callbackContext.error("URL argument missing.");
    }

    private void withRequestHeaderFields(JSONArray args, CallbackContext callbackContext) throws JSONException {
      if (args.length() > 1) {
          HttpRequestTracker tracker = httpRequestTrackers.get(args.getString(0));
          if (tracker != null) {
            JSONObject headersObj = args.getJSONObject(1);
            HashMap headersMap = new HashMap();
			      Iterator itor = headersObj.keys();
			      while (itor.hasNext()) {
				       String key = (String)itor.next();
				       String val = headersObj.getString(key);
				       ArrayList list = new ArrayList();
				       list.add(val);
				       // AppD magic headers must be uppercase CORE-39486
				      if (key.startsWith("adrum")) {
					       key = key.toUpperCase();
				      }
				     headersMap.put(key, list);
			      }
            tracker.withRequestHeaderFields(headersMap);
          } else
             callbackContext.error("Invalid tracker object.");
      } else
         callbackContext.error("URL argument missing.");
    }

    private void withResponseHeaderFields(JSONArray args, CallbackContext callbackContext) throws JSONException {
      if (args.length() > 1) {
          HttpRequestTracker tracker = httpRequestTrackers.get(args.getString(0));
          if (tracker != null) {
            JSONObject headersObj = args.getJSONObject(1);
            HashMap headersMap = new HashMap();
            Iterator itor = headersObj.keys();
            while (itor.hasNext()) {
               String key = (String)itor.next();
               String val = headersObj.getString(key);
               ArrayList list = new ArrayList();
               list.add(val);
               // AppD magic headers must be uppercase CORE-39486
               if (key.startsWith("adrum")) {
                 key = key.toUpperCase();
               }
               headersMap.put(key, list);
             }
            tracker.withResponseHeaderFields(headersMap);
          } else
             callbackContext.error("Invalid tracker object.");
      } else
         callbackContext.error("URL argument missing.");
    }

    private void withInstrumentationSource(JSONArray args, CallbackContext callbackContext) throws JSONException {
      if (args.length() > 1) {
          HttpRequestTracker tracker = httpRequestTrackers.get(args.getString(0));
          if (tracker != null) {
            tracker.withInstrumentationSource(args.getString(1));
          } else
             callbackContext.error("Invalid tracker object.");
      } else
         callbackContext.error("URL argument missing.");
    }

    private void reportDone(JSONArray args, CallbackContext callbackContext) throws JSONException {
      if (args.length() > 0) {
          HttpRequestTracker tracker = httpRequestTrackers.get(args.getString(0));
          if (tracker != null) {
            tracker.reportDone();
          } else
             callbackContext.error("Invalid tracker object.");
      } else
         callbackContext.error("URL argument missing.");
    }

    private void startNextSession(JSONArray args, CallbackContext callbackContext) throws JSONException {
        Instrumentation.startNextSession();
        callbackContext.success();
    }

    private void unblockScreenshots(JSONArray args, CallbackContext callbackContext) throws JSONException {
        Instrumentation.unblockScreenshots();
        callbackContext.success();
    }

    private void blockScreenshots(JSONArray args, CallbackContext callbackContext) throws JSONException {
        Instrumentation.blockScreenshots();
        callbackContext.success();
    }

    private void screenshotsBlocked(JSONArray args, CallbackContext callbackContext) throws JSONException {
        callbackContext.success(String.valueOf(Instrumentation.screenshotsBlocked()));
    }

    private void startSessionFrame(JSONArray args, CallbackContext callbackContext) throws JSONException {
       if (args.length() > 0) {
          SessionFrame sessionFrame = Instrumentation.startSessionFrame(args.getString(0));
          String uuid = UUID.randomUUID().toString();
          sessionFrames.put(uuid, sessionFrame);
          callbackContext.success(uuid);
       } else
          callbackContext.error("sessionFrameName argument is missing.");
    }

    private void updateSessionFrameName(JSONArray args, CallbackContext callbackContext) throws JSONException {
       if (args.length() > 1) {
          SessionFrame sessionFrame = sessionFrames.get(args.getString(0));
          if (sessionFrame != null) {
             sessionFrame.updateName(args.getString(1));
          } else
             callbackContext.error("Invalid SessionFrame object.");
       } else
          callbackContext.error("sessionFrameName argument is missing.");
    }

    private void endSessionFrame(JSONArray args, CallbackContext callbackContext) throws JSONException {
        SessionFrame sessionFrame = sessionFrames.get(args.getString(0));
        if (sessionFrame != null) {
            sessionFrame.end();
            sessionFrames.remove(sessionFrame);
        } else
            callbackContext.error("Invalid SessionFrame object.");
    }

    public void crash() throws RuntimeException {
        throw new RuntimeException("Crash Attempt");
    }

    public void flush() {
        try {
            HttpRequestTracker tracker = Instrumentation.beginHttpRequest(new URL("http://flush.queue"));
            tracker.withResponseCode(200).reportDone();
            //callbackContext.success();
        } catch (MalformedURLException mue) { }
    }

    public boolean checkPluginInitialized() {
       if (pluginInitialized) {
          return true;
       } else {
          return false;
       }
    }


    public String echo(String value) {
        Log.i("Echo", value);
        return value;
    }
}
