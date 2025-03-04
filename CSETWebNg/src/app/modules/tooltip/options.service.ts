import { InjectionToken } from '@angular/core';
import { TooltipOptions } from './options.interface';

/**
 * This is not a real service, but it looks like it from the outside.
 * It's just an InjectionToken used to import the config (initOptions) object, provided from the outside
 */
export const TooltipOptionsService = new InjectionToken<TooltipOptions>('TooltipOptions');
