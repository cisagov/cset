import { APP_INITIALIZER, Injectable } from '@angular/core';
import { HttpClient } from "@angular/common/http";

declare var globalConfig: any;

@Injectable({
  providedIn: 'root'
})
export class ConfigService {

  config: any = {};

  constructor( private httpClient: HttpClient) {  }

  async loadConfig() {
    this.config = globalConfig;
    return;
  }
}

export function ConfigFactory(config: ConfigService) {
  return () => config.loadConfig();
}
export function init() {
  return {
    provide: APP_INITIALIZER,
    useFactory: ConfigFactory,
    deps: [ConfigService],
    multi: true,
  };
}
const ConfigModule = {
  init: init,
};
export { ConfigModule };
