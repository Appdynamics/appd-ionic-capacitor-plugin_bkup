import { WebPlugin } from '@capacitor/core';

import type { ADEUMMobileCapacitorPluginPlugin } from './definitions';

export class ADEUMMobileCapacitorPluginWeb
  extends WebPlugin
  implements ADEUMMobileCapacitorPluginPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }

  async startTimer(options: { name: string }): Promise<void> {
    return;
  }
  async stopTimer(options: { name: string }): Promise<void> {
    return;
  }
  async stopTimer(options: { name: string }): Promise<void> {
    return;
  }
  async stopTimer(options: { name: string }): Promise<void> {
    return;
  }
  async stopTimer(options: { name: string }): Promise<void> {
    return;
  }
  async stopTimer(options: { name: string }): Promise<void> {
    return;
  }
  async stopTimer(options: { name: string }): Promise<void> {
    return;
  }
  async stopTimer(options: { name: string }): Promise<void> {
    return;
  }
  async stopTimer(options: { name: string }): Promise<void> {
    return;
  }
  async stopTimer(options: { name: string }): Promise<void> {
    return;
  }
  async stopTimer(options: { name: string }): Promise<void> {
    return;
  }
  async stopTimer(options: { name: string }): Promise<void> {
    return;
  }
  async stopTimer(options: { name: string }): Promise<void> {
    return;
  }
  async stopTimer(options: { name: string }): Promise<void> {
    return;
  }
  async stopTimer(options: { name: string }): Promise<void> {
    return;
  }
  async stopTimer(options: { name: string }): Promise<void> {
    return;
  }
  async stopTimer(options: { name: string }): Promise<void> {
    return;
  }
  async stopTimer(options: { name: string }): Promise<void> {
    return;
  }
  async getCorrelationHeaders(): Promise<{ headers: Map<string, string> }> {
    return ;
  }
  async startNextSession(): Promise<void> {
    return;
  }
  async unblockScreenshots(): Promise<void> {
    return;
  }
  async blockScreenshots(): Promise<void> {
    return;
  }
  async screenshotsBlocked(): Promise<{ screenshots_blocked: boolean }> {
    return { screenshots_blocked: false };
  }
  async startSessionFrame(options: {
    session_frame_name: string;
  }): Promise<{ session_frame: string }> {
    return { session_frame: "string" };
  }
  async endSessionFrame(options: { session_frame: string }): Promise<void> {
    return;
  }
  async updateSessionFrameName(options: {
    session_frame_name: string;
    session_frame: string;
  }): Promise<{ session_frame: string }> {
    return { session_frame: "string" };
  }
  async getVersion(): Promise<{ version: string }> {
    console.log('1.1.1');
    return { version: '1.1.1' };
  }
  async clear(): Promise<void> {
    return;
  }
}
