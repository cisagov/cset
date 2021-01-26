////////////////////////////////
//
//   Copyright 2020 Battelle Energy Alliance, LLC
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
import { HttpHeaders, HttpParams, HttpClient } from '@angular/common/http';
import { ConfigService } from './config.service';
import { ACETDomain, Domain } from '../models/questions.model';
import { Observable, Subject } from 'rxjs';
import { observeOn } from 'rxjs/operators';


const headers = {
  headers: new HttpHeaders()
    .set('Content-Type', 'application/json'),
  params: new HttpParams()
};


export class ACETFilter {
  DomainName: string;
  DomainId: number;
  Settings: ACETFilterSetting[];
}

export class ACETFilterSetting {
  Level: number;
  Value: boolean;
}

@Injectable({
  providedIn: 'root'
})
export class AcetFiltersService {


  /**
   * Trying a new way to manage these things.  This is now the master filter object.
   */
  public domainFilters: ACETFilter[];

  public overallIRP: number;

  /**
 * The page can store its model here for accessibility by question-extras
 */
  domains = null;


  constructor(
    private http: HttpClient,
    private configSvc: ConfigService
  ) {
    console.log('acet-filters.service constructor');
    this.getACETDomains().subscribe((domains: ACETDomain) => {
      this.domains = domains;
      this.initializeMatFilters(1);
    });
  }

  /**
  * Sets the starting value of the maturity filters, based on the 'stairstep.'
  * Any 'empty' values below the bottom of the band are set as well.
  */
  initializeMatFilters(targetLevel: number): Promise<any> {
    return new Promise((resolve) => {
      this.overallIRP = targetLevel;

      // if we have an IRP, default the maturity filters based on the stairstep.
      this.domainFilters = [];

      this.getFilters().subscribe((x: ACETFilter[]) => {
        if (!x || x.length === 0) {
          // the server has not filter pref set -- set default filters based on the bands
          this.setDmfFromDefaultBand(targetLevel);
          this.saveFilters(this.domainFilters).subscribe();
        } else {
          // rebuild domainFilters from what the API gave us
          this.domainFilters = [];
          for (const entry of x) {
            this.domainFilters.push({
              DomainName: entry.DomainName,
              DomainId: entry.DomainId,
              Settings: entry.Settings
            });
          }
        }

        // resolve this promise
        resolve(this.domainFilters);
      });
    });
  }

  /**
   * Gets the default stairstep and creates a filter profile
   * for all Domains from that stairstep.
   */
  setDmfFromDefaultBand(irp: number) {
    const bands = this.getStairstepOrig(irp);
    const dmf = this.domainFilters;

    this.domains.forEach((d: Domain) => {
      const settings: ACETFilterSetting[] = [];
      for (let i = 1; i <= 5; i++) {
        settings.push({
          Level: i,
          Value: bands.includes(i)
        });
      }
      dmf.push(
        {
          DomainName: d.DomainName,
          DomainId: 0,
          Settings: settings
        });
      // dmf.set(d.DomainName, new Map());
      // dmf.get(d.DomainName).set(1, bands.includes(1)); // B
      // dmf.get(d.DomainName).set(2, bands.includes(2)); // E
      // dmf.get(d.DomainName).set(3, bands.includes(3)); // Int
      // dmf.get(d.DomainName).set(4, bands.includes(4)); // A
      // dmf.get(d.DomainName).set(5, bands.includes(5)); // Inn

      const dFilter = this.domainFilters.find(f => f.DomainName == d.DomainName);
      let ix = 0;
      let belowBand = true;
      while (belowBand) {
        if (dFilter.Settings[ix].Value == false) {
          dFilter.Settings[ix].Value == true;
        } else {
          belowBand = false;
        }
      }
    });
  }

  /**
   * Returns the maturity levels applicable to the overall IRP,
   * based on the stairstep graph in the NCUA Guide.
   */
  getStairstepOrig(irp: number): number[] {
    switch (irp) {
      case 0:
        return [];
      case 1:
        return [1, 2]; // ['B', 'E'];
      case 2:
        return [1, 2, 3]; // ['B', 'E', 'Int'];
      case 3:
        return [2, 3, 4]; // ['E', 'Int', 'A'];
      case 4:
        return [3, 4, 5]; // ['Int', 'A', 'Inn'];
      case 5:
        return [4, 5]; // ['A', 'Inn'];
    }
  }



  /**
   * Returns the maturity levels applicable to the overall IRP,
   * based on the proposed 'grounded' stairstep graph.
   */
  getStairstepNew(irp: number): number[] {
    switch (irp) {
      case 0:
        return [];
      case 1:
        return [1]; // ['B'];
      case 2:
        return [1, 2]; // ['B', 'E'];
      case 3:
        return [1, 2, 3]; // ['B', 'E', 'Int'];
      case 4:
        return [1, 2, 3, 4]; // ['B', 'E', 'Int', 'A'];
      case 5:
        return [1, 2, 3, 4, 5]; // ['B', 'E', 'Int', 'A', 'Inn'];
    }
  }

  // /**
  //  * Indicates whether a certain filter is set to 'on'
  //  */
  // isDomainMatFilterSet(domainName: string, mat: number) {
  //   if (!this.domainMatFilters.get(domainName)) {
  //     return false;
  //   }

  //   return this.domainMatFilters.get(domainName).get(mat);
  // }

  /**
   * Returns true if no maturity filters are enabled.
   * This is used primarily to ngif the 'all filters are off' message.
   */
  maturityFiltersAllOff(domainName: string) {
    const targetFilter = this.domainFilters.find(f => f.DomainName == domainName);

    // If not ACET (no domain name), return false
    if (!domainName || domainName.length === 0
      || !this.domainFilters || !targetFilter) {
      return false;
    }

    return targetFilter.Settings.every(s => s.Value == false);
  }

  /**
   *
   */
  isDefaultMatLevel(mat: number) {
    const stairstepOrig = this.getStairstepOrig(this.overallIRP);
    if (!!stairstepOrig) {
      return stairstepOrig.includes(mat);
    }
    return false;
  }

  /**
   * 
   */
  resetDmf(irp: number) {
    this.getACETDomains().subscribe((domains: ACETDomain) => {
      this.domains = domains;
      this.domainFilters = [];
      this.setDmfFromDefaultBand(irp);
      this.saveFilters(this.domainFilters).subscribe();
    });
  }


  //------------------ API requests ------------------

  /**
   * 
   */
  getACETDomains() {
    return this.http.get(this.configSvc.apiUrl + 'ACETDomains');
  }

  /**
   * 
   */
  getFilters() {
    return this.http.get(this.configSvc.apiUrl + 'GetAcetFilters');
  }

  /**
   * Sets a bit ('val') for the domain and level.  The bit indicates if the fiter is
   * on or of.
   */
  saveFilter(domainName: string, level: number, val: any) {
    const setting = { DomainName: domainName, Level: level, Value: val };
    return this.http.post(this.configSvc.apiUrl + 'SaveAcetFilter', setting, headers);
  }

  /**
   * 
   */
  saveFilters(filters: ACETFilter[]) {
    // const saveValue: ACETFilter[] = [];

    // for (const domainEntry of Array.from(filters.entries())) {
    //   const x: ACETFilter = new ACETFilter();
    //   x.DomainName = domainEntry[0];
    //   x.DomainId = 0;
    //   domainEntry[1].forEach(setting => {
    //     x.Settings.push({ 
    //       Level: setting[0], 
    //       Value: setting[1]
    //     });
    //   });

    //   saveValue.push(x);
    // }

    return this.http.post(this.configSvc.apiUrl + 'SaveAcetFilters', filters, headers);
  }
}
