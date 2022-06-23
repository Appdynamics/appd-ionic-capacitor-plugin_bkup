import { WebPlugin } from '@capacitor/core';

import type { ADEUMMobileCapacitorPluginPlugin } from './definitions';

export class ADEUMMobileCapacitorPluginWeb
  extends WebPlugin
  implements ADEUMMobileCapacitorPluginPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
  async startTimer(options: { name: string; }): void {
      return;
  }
  async getVersion(): Promise<{ version: string }> {
    console.log('1.1.1');
    return { version: '1.1.1' };
  }
  async clear(): Promise<void> {
    return; 
  }
}
