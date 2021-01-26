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


const headers = {
  headers: new HttpHeaders()
    .set('Content-Type', 'application/json'),
  params: new HttpParams()
};


export class ACETFilter {
  DomainName: string;
  DomainId: number;
  Settings: ACETFilterSetting[];
  // B: boolean;
  // E: boolean;
  // Int: boolean;
  // A: boolean;
  // Inn: boolean;
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
 * Tracks the maturity filter settings across all domains
 */
  public domainMatFilters: Map<string, Map<number, boolean>>;

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
      console.log('acet-filters.service set domains to...');
      console.log(this.domains);
      this.initializeMatFilters(1);
    });
  }

  /**
  * Sets the starting value of the maturity filters, based on the 'stairstep.'
  * Any 'empty' values below the bottom of the band are set as well.
  */
  initializeMatFilters(targetLevel: number) {
    this.overallIRP = targetLevel;

    // if we have an IRP, default the maturity filters based on the stairstep.
    this.domainMatFilters = new Map();

    this.getFilters().subscribe((x: ACETFilter[]) => {
      // the server has not filter pref set -- set default filters based on the bands
      if (!x || x.length === 0) {
        this.setDmfFromDefaultBand(targetLevel);
        this.saveFilters(this.domainMatFilters).subscribe();
      } else {
        for (const entry of x) {
          const tmpMap = new Map();
          this.domainMatFilters.set(entry.DomainName, tmpMap);
          entry.Settings.forEach(s => {
            tmpMap.set(s.Level, s.Value);
          });
        }
      }
    });

    console.log('initializeMatFilters DMF...');
    console.log(this.domainMatFilters);
  }

  /**
   * Gets the default stairstep and creates a filter profile
   * for all Domains from that stairstep.
   */
  setDmfFromDefaultBand(irp: number) {
    const bands = this.getStairstepOrig(irp);
    const dmf = this.domainMatFilters;

    this.domains.forEach((d: Domain) => {
      dmf.set(d.DomainName, new Map());
      dmf.get(d.DomainName).set(1, bands.includes(1)); // B
      dmf.get(d.DomainName).set(2, bands.includes(2)); // E
      dmf.get(d.DomainName).set(3, bands.includes(3)); // Int
      dmf.get(d.DomainName).set(4, bands.includes(4)); // A
      dmf.get(d.DomainName).set(5, bands.includes(5)); // Inn

      // bottom fill
      let belowBand = true;
      const i = this.domainMatFilters.get(d.DomainName).entries();
      let e = i.next();
      while (!e.done && belowBand) {
        if (e.value[1]) {
          belowBand = false;
        } else {
          dmf.get(d.DomainName).set(e.value[0], true);
        }
        e = i.next();
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
    // If not ACET (no domain name), return false
    if (!domainName || domainName.length === 0
      || !this.domainMatFilters || !this.domainMatFilters.get(domainName)) {
      return false;
    }

    const i = this.domainMatFilters.get(domainName).entries();
    let e = i.next();
    while (!e.done) {
      if (e.value[1]) {
        return false;
      }
      e = i.next();
    }

    return true;
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
      this.domainMatFilters = new Map();
      this.setDmfFromDefaultBand(irp);
      this.saveFilters(this.domainMatFilters).subscribe();
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
   * 
   */
  saveFilter(domainName: string, f: number, e: any) {
    const setting = { DomainName: domainName, Level: f, Value: e };
    return this.http.post(this.configSvc.apiUrl + 'SaveAcetFilter', setting, headers);
  }

  /**
   * 
   */
  saveFilters(filters: Map<string, Map<number, boolean>>) {
    const saveValue: ACETFilter[] = [];

    console.log('saveFilters...');
    console.log(filters);

    for (const entry of Array.from(filters.entries())) {
      const x: ACETFilter = new ACETFilter();
      x.DomainName = entry[0];
      x.DomainId = 0;
      // entry.forEach(e => {
      //   x.Settings.push{ Level: entry[1]});
      // });
      // x.B = entry[1].get(1);
      // x.E = entry[1].get(2);
      // x.Int = entry[1].get(3);
      // x.A = entry[1].get(4);
      // x.Inn = entry[1].get(5);

      saveValue.push(x);
    }

    return this.http.post(this.configSvc.apiUrl + 'SaveAcetFilters', saveValue, headers);
  }
}
