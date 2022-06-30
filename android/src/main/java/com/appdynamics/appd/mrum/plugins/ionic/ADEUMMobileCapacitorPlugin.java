package com.appdynamics.appd.mrum.plugins.ionic;

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
        call.resolve();
    }

    // Maturity, one discovers, has everything to do with the acceptance of ‘not knowing'.

    @PluginMethod(returnType = PluginMethod.RETURN_NONE)
    public void stopTimerWithName(PluginCall call) {
        String name = call.getString("name").toString();
        name = name.trim().length() == 0 ? PLACEHOLDER_METRIC : name;
        implementation.stopTimerWithName(name);
        call.resolve();
    }

    @PluginMethod(returnType = PluginMethod.RETURN_NONE)
    public void reportMetricWithName(PluginCall call) {
        String name = call.getString("name").toString();
        name = name.trim().length() == 0 ? PLACEHOLDER_METRIC : name;
        Integer value = call.getInt("value");
        implementation.reportMetricWithName(name, value);
        call.resolve();
    }
    @PluginMethod
    public void leaveBreadcrumb(PluginCall call) {
        String name = call.getString("name").toString();
        name = name.trim().length() == 0 ? PLACEHOLDER_METRIC : name;
        implementation.leaveBreadcrumb(name);
        call.resolve();
    }
    @PluginMethod
    public void setUserData(PluginCall call) {
        String key = call.getString("key").toString();
        key = key.trim().length() == 0 ? PLACEHOLDER_METRIC : key;
        String value = call.getString("value").toString();
        value = value.trim().length() == 0 ? PLACEHOLDER_METRIC : value;
        if (!key.equals(PLACEHOLDER_KEY)) {
            implementation.setUserData(key, value);
        }
        call.resolve();
    }

    @PluginMethod
    public void removeUserData(PluginCall call){
        String key = call.getString("key").toString();
        key = key.trim().length() == 0 ? PLACEHOLDER_METRIC : key;
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
        String className = call.getString("className").toString();
        String methodName = call.getString("methodName").toString();
        JSArray args = call.getArray("withArguments");
        if (className.trim().length()!=0 && methodName.trim().length()!=0){
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
            implementation.endCall(tracker);
        }
        call.resolve();
    }

    @PluginMethod
    public void beginHTTPRequest(PluginCall call){
        String url = call.getString("url").toString();
        url = url.trim().length() == 0 ? "" : url;
        
        if (url.length() > 0){

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
