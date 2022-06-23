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
  async beginCall(options: {
    className: string;
    methodName: string;
    withArguments: [];
  }): Promise<{ call_tracker: string }> {
    return;
  }
  async endCall(options: { call_tracker: string }): Promise<void> {
    return;
  }
  async beginHttpRequest(options: {
    url: string;
  }): Promise<{ http_tracker: string }> {
    return { http_tracker: 'string' };
  }
  async reportDone(options: { http_tracker: string }): Promise<void> {
    return;
  }
  async withResponseCode(options: {
    http_tracker: string;
    status_code: string;
  }): Promise<void> {
    return;
  }
  async withResponseContentLength(options: {
    http_tracker: string;
    content_length: number;
  }): Promise<void> {
    return;
  }
  async withRequestContentLength(options: {
    http_tracker: string;
    content_length: number;
  }): Promise<void> {
    return;
  }
  async withResponseHeaderFields(options: {
    http_tracker: string;
    http_headers: Map<string, string>;
  }): Promise<void> {
    return;
  }
  async withRequestHeaderFields(options: {
    http_tracker: string;
    http_headers: Map<string, string>;
  }): Promise<void> {
    return;
  }
  async withInstrumentationSource(options: {
    http_tracker: string;
    information_source: string;
  }): Promise<void> {
    return;
  }
  async withErrorMessage(options: {
    http_tracker: string;
    error_message: string;
  }): Promise<void> {
    return;
  }
  async getCorrelationHeaders(): Promise<{ headers: Map<string, string> }> {
    return { headers: new Map() };
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
    return { session_frame: 'string' };
  }
  async endSessionFrame(options: { session_frame: string }): Promise<void> {
    return;
  }
  async updateSessionFrameName(options: {
    session_frame_name: string;
    session_frame: string;
  }): Promise<{ session_frame: string }> {
    return { session_frame: 'string' };
  }
  async getVersion(): Promise<{ version: string }> {
    console.log('1.1.1');
    return { version: '1.1.1' };
  }
  async clear(): Promise<void> {
    return;
  }
}
