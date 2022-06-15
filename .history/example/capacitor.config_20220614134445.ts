import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.appdynamics.appd.mrum.plugins.ionic',
  appName: 'appd-ionic-capacitor-plugin',
  webDir: 'www',
  plugins: {
    ADEUMMobileCapacitorPlugin: {
      ADEUM_APP_KEY: 'key_here',
      ADEUM_COLLECTOR_URL: 'http://account.appdynamics.com',
      ADEUM_SCREENSHOT_URL: '',
      screenshotsEADEUM_SCREENSHOTS_ENABLEDnabled: '',
      loggingLevel: '',
      reachabilityHost: '',
      interactionCaptureMode: '',
    },
  },
};

export default config;
