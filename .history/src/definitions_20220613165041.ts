export interface ADEUMMobileCapacitorPluginPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
  getVersion(): Promise<{ version: string }>;
  onReset(): void;
}
declare module '@capacitor/cli' {
  export interface PluginsConfig {
    ADEUMMobileCapacitorPlugin?: {
      appKey: String;
      collectorUrl: String;
      screenshotUrl: String;
      screenshotsEnabled: String;
      loggingLevel: String;
      reachabilityHost: String;
      interactionCaptureMode: String;
    };
  }
}
