package com.appdynamics.appd.mrum.plugins.ionic;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "ADEUMMobileCapacitorPlugin")
public class ADEUMMobileCapacitorPluginPlugin extends Plugin {

    private ADEUMMobileCapacitorPlugin implementation = new ADEUMMobileCapacitorPlugin();

    @PluginMethod
    public void echo(PluginCall call) {
        String value = call.getString("value");

        JSObject ret = new JSObject();
        ret.put("value", implementation.echo(value));
        call.resolve(ret);
    }

    @PluginMethod(returnType = PluginMethod.RETURN_NONE)
    public void startTimer(PluginCall call) {
        String name = call.getString("name");
        call.resolve();
    }

    @PluginMethod
    public void getVersion(PluginCall call) {
        JSObject ret = new JSObject();
        ret.put("version", implementation.getVersion());
        call.resolve(ret);
    }

    @PluginMethod(returnType = PluginMethod.RETURN_NONE)
    public void clear(PluginCall call) {
        implementation.clear();
    }

    @PluginMethod
    public void checkPluginInitialized(PluginCall call) {
        boolean is_initialized = false;
        is_initialized =    implementation.checkPluginInitialized();
        //JSObject ret = new JSObject();
        if (!is_initialized){
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
        try{
            implementation.crash();
        }catch(RuntimeException re){
            ret.put("exception_type_name", re.getClass().getCanonicalName());
            ret.put("exception_message", re.getMessage());
            call.resolve(ret);
        }
        
    }
}
