/// <reference types="@capacitor/cli" />
export interface ADEUMMobileCapacitorPluginPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
  startTimer(options: { name: string }): Promise<void>;
  stopTimer(options: { name: string }): Promise<void>; 
  reportMetricWithName(options: { name: string; value: number }): Promise<void>; 
  leaveBreadcrumb(options: { name: string }): Promise<void>; 
  setUserData(options: { key: string; value: string }): Promise<void>; 
  removeUserData(options: { key: string }): Promise<void>; 
  beginCall(options: {
    className: string;
    methodName: string;
    withArguments: [];
  }): Promise<{ call_tracker: string }>; 
  endCall(options: { call_tracker: string }): Promise<void>; 
  beginHttpRequest(options: { url: string }): Promise<{ http_tracker: string }>; 
  reportDone(options: { http_tracker: string }): Promise<void>; 
  withResponseCode(options: {
    http_tracker: string;
    status_code: string;
  }): Promise<void>;
  withResponseContentLength(options: {
    http_tracker: string;
    content_length: number;
  }): Promise<void>;
  withRequestContentLength(options: {
    http_tracker: string;
    content_length: number;
  }): Promise<void>; 
  withResponseHeaderFields(options: {
    http_tracker: string;
    http_headers: Map<string, string>;
  }): Promise<void>; 
  withRequestHeaderFields(options: {
    http_tracker: string;
    http_headers: Map<string, string>;
  }): Promise<void>; 
  withInstrumentationSource(options: {
    http_tracker: string;
    information_source: string;
  }): Promise<void>;
  withErrorMessage(options: {
    http_tracker: string;
    error_message: string;
  }): Promise<void>;
  getCorrelationHeaders(): Promise<{ headers: Map<string, string> }>;
  startNextSession(): Promise<void>; 
  unblockScreenshots(): Promise<void>; 
  blockScreenshots(): Promise<void>; 
  screenshotsBlocked(): Promise<{ screenshots_blocked: boolean }>; 
  takeScreenshot(): Promise<void>; 
  startSessionFrame(options: {
    session_frame_name: string;
  }): Promise<{ session_frame: string }>; 
  endSessionFrame(options: { session_frame: string }): Promise<void>;
  updateSessionFrameName(options: {
    session_frame_name: string;
    session_frame: string;
  }): Promise<{ session_frame: string }>; 

  getVersion(): Promise<{ version: string }>; 
  clear(): Promise<void>;
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
