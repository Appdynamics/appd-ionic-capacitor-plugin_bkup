import { registerPlugin } from '@capacitor/core';

import type { ADEUMMobileCapacitorPluginPlugin } from './definitions';

const ADEUMMobileCapacitorPlugin = registerPlugin<ADEUMMobileCapacitorPluginPlugin>(
  'ADEUMMobileCapacitorPlugin',
  {
    web: () => import('./web').then(m => new m.ADEUMMobileCapacitorPluginWeb()),
  },
);

export * from './definitions';
export { ADEUMMobileCapacitorPlugin };
