////////////////////////////////
//
//   Copyright 2024 Battelle Energy Alliance, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
////////////////////////////////
import { Injectable } from '@angular/core';
import { Observable, Subject } from 'rxjs';

import { Utilities } from './utilities.service';

@Injectable()
/**
* Provides a wrapper for accessing the web storage API and synchronizing session storage across tabs/windows.
*/
export class LocalStoreManager {
  private static syncListenerInitialised = false;

  public static readonly DBKEY_USER_DATA = 'user_data';
  private static readonly DBKEY_SYNC_KEYS = 'sync_keys';
  private syncKeys: string[] = [];
  private initEvent = new Subject();

  private reservedKeys: string[] =
    [
      'sync_keys',
      'addToSyncKeys',
      'removeFromSyncKeys',
      'getSessionStorage',
      'setSessionStorage',
      'addToSessionStorage',
      'removeFromSessionStorage',
      'clearAllSessionsStorage'
    ];


  public initialiseStorageSyncListener() {
    if (LocalStoreManager.syncListenerInitialised == true) {
      return;
    }

    LocalStoreManager.syncListenerInitialised = true;
    window.addEventListener('storage', this.sessionStorageTransferHandler, false);
    this.syncSessionStorage();
  }

  public deinitialiseStorageSyncListener() {
    window.removeEventListener('storage', this.sessionStorageTransferHandler, false);
    LocalStoreManager.syncListenerInitialised = false;
  }

  public clearAllStorage() {
    this.clearAllSessionsStorage();
    this.clearLocalStorage();
  }

  public clearAllSessionsStorage() {
    this.clearInstanceSessionStorage();
    localStorage.removeItem(LocalStoreManager.DBKEY_SYNC_KEYS);

    localStorage.setItem('clearAllSessionsStorage', '_dummy');
    localStorage.removeItem('clearAllSessionsStorage');
  }

  public clearInstanceSessionStorage() {
    localStorage.clear();
    this.syncKeys = [];
  }

  public clearLocalStorage() {
    localStorage.clear();
  }

  public saveSessionData(data: any, key = LocalStoreManager.DBKEY_USER_DATA) {
    this.testForInvalidKeys(key);

    this.removeFromSyncKeys(key);
    localStorage.removeItem(key);
    this.sessionStorageSetItem(key, data);
  }

  public saveSyncedSessionData(data: any, key = LocalStoreManager.DBKEY_USER_DATA) {
    this.testForInvalidKeys(key);

    localStorage.removeItem(key);
    this.addToSessionStorage(data, key);
  }

  public savePermanentData(data: any, key = LocalStoreManager.DBKEY_USER_DATA) {
    this.testForInvalidKeys(key);

    this.removeFromSessionStorage(key);
    this.localStorageSetItem(key, data);
  }

  public moveDataToSessionStorage(key = LocalStoreManager.DBKEY_USER_DATA) {
    this.testForInvalidKeys(key);

    const data = this.getData(key);

    if (data == null) {
      return;
    }

    this.saveSessionData(data, key);
  }

  public moveDataToSyncedSessionStorage(key = LocalStoreManager.DBKEY_USER_DATA) {
    this.testForInvalidKeys(key);

    const data = this.getData(key);

    if (data == null) {
      return;
    }

    this.saveSyncedSessionData(data, key);
  }

  public moveDataToPermanentStorage(key = LocalStoreManager.DBKEY_USER_DATA) {
    this.testForInvalidKeys(key);

    const data = this.getData(key);

    if (data == null) {
      return;
    }

    this.savePermanentData(data, key);
  }

  public exists(key = LocalStoreManager.DBKEY_USER_DATA) {
    let data = localStorage.getItem(key);

    if (data == null) {
      data = localStorage.getItem(key);
    }

    return data != null;
  }

  public getData(key = LocalStoreManager.DBKEY_USER_DATA) {
    this.testForInvalidKeys(key);

    let data = this.sessionStorageGetItem(key);

    if (data == null) {
      data = this.localStorageGetItem(key);
    }

    return data;
  }

  public getDataObject<T>(key = LocalStoreManager.DBKEY_USER_DATA, isDateType = false): T {
    let data = this.getData(key);

    if (data != null) {
      if (isDateType) {
        data = new Date(data);
      }
      return data as T;
    } else {
      return null;
    }
  }

  public deleteData(key = LocalStoreManager.DBKEY_USER_DATA) {
    this.testForInvalidKeys(key);

    this.removeFromSessionStorage(key);
    localStorage.removeItem(key);
  }

  public getInitEvent(): Observable<{}> {
    return this.initEvent.asObservable();
  }

  private sessionStorageTransferHandler = (event: StorageEvent) => {
    if (!event.newValue) {
      return;
    }

    if (event.key == 'getSessionStorage') {
      if (localStorage.length) {
        this.localStorageSetItem('setSessionStorage', localStorage);
        localStorage.removeItem('setSessionStorage');
      }
    } else if (event.key == 'setSessionStorage') {

      if (!this.syncKeys.length) {
        this.loadSyncKeys();
      }
      const data = JSON.parse(event.newValue);
      // console.info("Set => Key: Transfer setSessionStorage" + ",  data: " + JSON.stringify(data));

      for (const key in data) {

        if (this.syncKeysContains(key)) {
          this.sessionStorageSetItem(key, JSON.parse(data[key]));
        }
      }

      this.onInit();
    } else if (event.key == 'addToSessionStorage') {

      const data = JSON.parse(event.newValue);

      // console.warn("Set => Key: Transfer addToSessionStorage" + ",  data: " + JSON.stringify(data));

      this.addToSessionStorageHelper(data.data, data.key);
    } else if (event.key == 'removeFromSessionStorage') {

      this.removeFromSessionStorageHelper(event.newValue);
    } else if (event.key == 'clearAllSessionsStorage' && localStorage.length) {
      this.clearInstanceSessionStorage();
    } else if (event.key == 'addToSyncKeys') {
      this.addToSyncKeysHelper(event.newValue);
    } else if (event.key == 'removeFromSyncKeys') {
      this.removeFromSyncKeysHelper(event.newValue);
    }
  }

  private syncSessionStorage() {
    localStorage.setItem('getSessionStorage', '_dummy');
    localStorage.removeItem('getSessionStorage');
  }

  private addToSessionStorage(data: any, key: string) {
    this.addToSessionStorageHelper(data, key);
    this.addToSyncKeysBackup(key);

    this.localStorageSetItem('addToSessionStorage', { key, data });
    localStorage.removeItem('addToSessionStorage');
  }

  private addToSessionStorageHelper(data: any, key: string) {
    this.addToSyncKeysHelper(key);
    this.sessionStorageSetItem(key, data);
  }

  private removeFromSessionStorage(keyToRemove: string) {
    this.removeFromSessionStorageHelper(keyToRemove);
    this.removeFromSyncKeysBackup(keyToRemove);

    localStorage.setItem('removeFromSessionStorage', keyToRemove);
    localStorage.removeItem('removeFromSessionStorage');
  }

  private removeFromSessionStorageHelper(keyToRemove: string) {

    localStorage.removeItem(keyToRemove);
    this.removeFromSyncKeysHelper(keyToRemove);
  }

  private testForInvalidKeys(key: string) {
    if (!key) {
      throw new Error('key cannot be empty');
    }

    if (this.reservedKeys.some(x => x == key)) {
      throw new Error(`The storage key "${key}" is reserved and cannot be used. Please use a different key`);
    }
  }

  private syncKeysContains(key: string) {

    return this.syncKeys.some(x => x == key);
  }

  private loadSyncKeys() {
    if (this.syncKeys.length) {
      return;
    }

    this.syncKeys = this.getSyncKeysFromStorage();
  }

  private getSyncKeysFromStorage(defaultValue: string[] = []): string[] {
    const data = this.localStorageGetItem(LocalStoreManager.DBKEY_SYNC_KEYS);

    if (data == null) {
      return defaultValue;
    } else {
      return data as string[];
    }
  }

  private addToSyncKeys(key: string) {
    this.addToSyncKeysHelper(key);
    this.addToSyncKeysBackup(key);

    localStorage.setItem('addToSyncKeys', key);
    localStorage.removeItem('addToSyncKeys');
  }

  private addToSyncKeysBackup(key: string) {
    const storedSyncKeys = this.getSyncKeysFromStorage();

    if (!storedSyncKeys.some(x => x == key)) {
      storedSyncKeys.push(key);
      this.localStorageSetItem(LocalStoreManager.DBKEY_SYNC_KEYS, storedSyncKeys);
    }
  }

  private removeFromSyncKeysBackup(key: string) {
    const storedSyncKeys = this.getSyncKeysFromStorage();

    const index = storedSyncKeys.indexOf(key);

    if (index > -1) {
      storedSyncKeys.splice(index, 1);
      this.localStorageSetItem(LocalStoreManager.DBKEY_SYNC_KEYS, storedSyncKeys);
    }
  }

  private addToSyncKeysHelper(key: string) {
    if (!this.syncKeysContains(key)) {
      this.syncKeys.push(key);
    }
  }

  private removeFromSyncKeys(key: string) {
    this.removeFromSyncKeysHelper(key);
    this.removeFromSyncKeysBackup(key);

    localStorage.setItem('removeFromSyncKeys', key);
    localStorage.removeItem('removeFromSyncKeys');
  }

  private removeFromSyncKeysHelper(key: string) {
    const index = this.syncKeys.indexOf(key);

    if (index > -1) {
      this.syncKeys.splice(index, 1);
    }
  }

  private localStorageSetItem(key: string, data: any) {
    localStorage.setItem(key, JSON.stringify(data));
  }

  private sessionStorageSetItem(key: string, data: any) {
    localStorage.setItem(key, JSON.stringify(data));
  }

  private localStorageGetItem(key: string) {
    return Utilities.JsonTryParse(localStorage.getItem(key));
  }

  private sessionStorageGetItem(key: string) {
    return Utilities.JsonTryParse(localStorage.getItem(key));
  }

  private onInit() {
    setTimeout(() => {
      this.initEvent.next();
      this.initEvent.complete();
    });
  }
}