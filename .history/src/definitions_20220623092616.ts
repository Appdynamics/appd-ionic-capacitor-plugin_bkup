/// <reference types="@capacitor/cli" />
export interface ADEUMMobileCapacitorPluginPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
  startTimer(options: { name: string }): void; //ios
  stopTimer(options: { name: string }): void; //ios
  reportMetricWithName(options: { name: string; value: number }): void; //ios
  leaveBreadcrumb(options: { name: string }): void; //ios
  setUserData(options: { key: string; value: string }): void; //ios
  removeUserData(options: { key: string }): void; //ios
  takeScreenshot(): void; //ios
  beginCall(options: {
    className: string;
    methodName: string;
    withArguments: [];
  }): Promise<{ call_tracker: string }>; //ios
  endCall(options: { call_tracker: string }): void; //ios
  beginHttpRequest(options: { url: string }): Promise<{ http_tracker: string }>; //ios
  reportDone(options: { http_tracker: string }): void; //ios
  withResponseCode(options: {
    http_tracker: string;
    status_code: string;
  }): void; //ios
  withResponseContentLength(options: {
    http_tracker: string;
    content_length: number;
  }): void; //ios
  withRequestContentLength(options: {
    http_tracker: string;
    content_length: number;
  }): void; //ios
  withRequestContentLength(options: {
    http_tracker: string;
    content_length: number;
  }): void; //ios
  getVersion(): Promise<{ version: string }>; //android only
  clear(): void; //ios only
}
declare module '@capacitor/cli' {
  export interface PluginsConfig {
    ADEUMMobileCapacitorPlugin?: {
      ADEUM_APP_KEY: string;
      ADEUM_COLLECTOR_URL: string;
      ADEUM_SCREENSHOT_URL: string;
      ADEUM_SCREENSHOTS_ENABLED: boolean;
      ADEUM_LOGGING_LEVEL: number;
      ADEUM_REACHABILITY_HOST: string;
      ADEUM_INTERACTION_CAPTURE_MODE: number;
    };
  }
}
