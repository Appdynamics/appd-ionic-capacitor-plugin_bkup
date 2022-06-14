import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.appdynamics.appd.mrum.plugins.ionic',
  appName: 'appd-ionic-capacitor-plugin',
  webDir: 'www',
  plugins: {
    ADEUMMobileCapacitorPlugin: {
      appKey: "key_here",
      collectorUrl: "http://account.appdynamics.com",
      screenshotUrl: "",
      screenshotsEnabled: "",
      loggingLevel: "",
      reachabilityHost: "",
      interactionCaptureMode: "",
    },
  },
};

export default config;
