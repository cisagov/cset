export interface AppVersion {
  majorVersion: number;
  minorVersion: number;
  patch: number;
  build: number;
  versionString?: string;
  patchNotes?: string;
  currentVersion?:string;
}
