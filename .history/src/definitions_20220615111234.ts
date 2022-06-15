/// <reference types="@capacitor/cli" />
export interface ADEUMMobileCapacitorPluginPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
  startTimerWithName()
  getVersion(): Promise<{ version: string }>;
  onReset(): void;
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
