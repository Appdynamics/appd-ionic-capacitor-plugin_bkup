import { WebPlugin } from '@capacitor/core';
import { v4 as uuid } from 'uuid';
import type { ADEUMMobileCapacitorPluginPlugin } from './definitions';

export class ADEUMMobileCapacitorPluginWeb
  extends WebPlugin
  implements ADEUMMobileCapacitorPluginPlugin {
  constructor() {
    super();
  }
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }

  async startTimer(options: { name: string }): Promise<void> {
    console.log('startTimer', options);
    return;
  }
  async stopTimer(options: { name: string }): Promise<void> {
    console.log('stopTimer', options);
    return;
  }
  async reportMetricWithName(options: {
    name: string;
    value: number;
  }): Promise<void> {
    console.log('reportMetricWithName', options);
    return;
  }
  async leaveBreadcrumb(options: { name: string }): Promise<void> {
    console.log('leaveBreadcrumb', options);
    return;
  }
  async setUserData(options: { key: string; value: string }): Promise<void> {
    console.log('setUserData', options);
    return;
  }
  async removeUserData(options: { key: string }): Promise<void> {
    console.log('removeUserData', options);
    return;
  }

  async beginCall(options: {
    className: string;
    methodName: string;
    withArguments: [];
  }): Promise<{ call_tracker: string }> {
    console.log('beginCall', options);
    return { call_tracker: uuid() };
  }
  async endCall(options: { call_tracker: string }): Promise<void> {
    console.log('endCall', options);
    return;
  }
  async beginHttpRequest(options: {
    url: string;
  }): Promise<{ http_tracker: string }> {
    console.log('beginHttpRequest', options);
    return { http_tracker:  };
  }
  async reportDone(options: { http_tracker: string }): Promise<void> {
    console.log('reportDone', options);
    return;
  }
  async withResponseCode(options: {
    http_tracker: string;
    status_code: string;
  }): Promise<void> {
    console.log('withResponseCode', options);
    return;
  }
  async withResponseContentLength(options: {
    http_tracker: string;
    content_length: number;
  }): Promise<void> {
    console.log('withResponseContentLength', options);
    return;
  }
  async withRequestContentLength(options: {
    http_tracker: string;
    content_length: number;
  }): Promise<void> {
    console.log('withRequestContentLength', options);
    return;
  }
  async withResponseHeaderFields(options: {
    http_tracker: string;
    http_headers: Map<string, string>;
  }): Promise<void> {
    console.log('withResponseHeaderFields', options);
    return;
  }
  async withRequestHeaderFields(options: {
    http_tracker: string;
    http_headers: Map<string, string>;
  }): Promise<void> {
    console.log('withRequestHeaderFields', options);
    return;
  }
  async withInstrumentationSource(options: {
    http_tracker: string;
    information_source: string;
  }): Promise<void> {
    console.log('withInstrumentationSource', options);
    return;
  }
  async withErrorMessage(options: {
    http_tracker: string;
    error_message: string;
  }): Promise<void> {
    console.log('withErrorMessage', options);
    return;
  }
  async getCorrelationHeaders(): Promise<{ headers: Map<string, string> }> {
    console.log('getCorrelationHeaders');
    return { headers: new Map() };
  }
  async startNextSession(): Promise<void> {
    console.log('startNextSession');
    return;
  }
  async unblockScreenshots(): Promise<void> {
    console.log('unblockScreenshots');
    return;
  }
  async blockScreenshots(): Promise<void> {
    console.log('blockScreenshots');
    return;
  }
  async screenshotsBlocked(): Promise<{ screenshots_blocked: boolean }> {
    console.log('screenshotsBlocked');
    return { screenshots_blocked: false };
  }
  async takeScreenshot(): Promise<void> {
    console.log('takeScreenshot');
    return;
  }
  async startSessionFrame(options: {
    session_frame_name: string;
  }): Promise<{ session_frame: string }> {
    console.log('should be running');
    console.log('startSessionFrame', options);
    return { session_frame: 'session_frame_guid' };
  }
  async endSessionFrame(options: { session_frame: string }): Promise<void> {
    console.log('endSessionFrame', options);
    return;
  }
  async updateSessionFrameName(options: {
    session_frame_name: string;
    session_frame: string;
  }): Promise<{ session_frame: string }> {
    console.log('updateSessionFrameName', options);
    return { session_frame: options.session_frame };
  }
  async getVersion(): Promise<{ version: string }> {
    console.log('getVersion: 1.1.1');
    return { version: '1.1.1' };
  }
  async clear(): Promise<void> {
    console.log('clear');
    return;
  }
}
