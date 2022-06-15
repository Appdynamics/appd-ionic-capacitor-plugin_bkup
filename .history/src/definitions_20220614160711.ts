/// <reference types="@capacitor/cli" />
export interface ADEUMMobileCapacitorPluginPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
  getVersion(): Promise<{ version: string }>;
  onReset(): void;
}
declare module '@capacitor/cli' {
  export interface PluginsConfig {
    ADEUMMobileCapacitorPlugin?: {
      ADEUM_APP_KEY: String;
      ADEUM_COLLECTOR_URL: String;
      ADEUM_SCREENSHOT_URL: String;
      ADEUM_SCREENSHOTS_ENABLED: Boolean;
      ADEUM_LOGGING_LEVEL: Ui;
      ADEUM_REACHABILITY_HOST: String;
      ADEUM_INTERACTION_CAPTURE_MODE: String;
    };
  }
}
