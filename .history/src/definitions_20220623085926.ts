/// <reference types="@capacitor/cli" />
export interface ADEUMMobileCapacitorPluginPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
  startTimerWithName(options: { name: string }): void;
  stopTimerWithName(options: { name: string }): void;
  reportMetricWithName(options: { name: string; value: number }): void;
  leaveBreadcrumb(options: { name: string }): void;
  setUserData(options: { key: string; value: string }): void;
  removeUserData(options: { key: string }): void;
  takeScreenshot(): void;
  getVersion(): Promise<{ version: string }>;
  clear(): void;
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
