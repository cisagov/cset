import { Injectable } from '@angular/core';
import { ACETDomain, Domain } from '../models/questions.model';
import { ACETFilter, AcetFiltersService } from './acet-filters.service';

@Injectable({
  providedIn: 'root'
})
export class QuestionsAcetService {

  public overallIRP: number;

  /**
   * Tracks the maturity filter settings across all domains
   */
  public domainMatFilters: Map<string, Map<string, boolean>>;

  /**
   * The page can store its model here for accessibility by question-extras
   */
  domains = null;

  /**
   * 
   */
  constructor(
    private acetFilterSvc: AcetFiltersService
  ) { 
    this.initializeMatFilters(1);
  }


  /**
  * Sets the starting value of the maturity filters, based on the 'stairstep.'
  * Any 'empty' values below the bottom of the band are set as well.
  */
  initializeMatFilters(irp: number) {
    this.overallIRP = irp;

    // if we have an IRP, default the maturity filters based on the stairstep.
    this.domainMatFilters = new Map();

    this.acetFilterSvc.getFilters().subscribe((x: ACETFilter[]) => {
      // set the filters based on the bands
      if ((x === undefined) || (x.length === 0)) {
        this.getDefaultBand(irp);
        if ((x === undefined) || (x.length === 0)) {
          this.acetFilterSvc.saveFilters(this.domainMatFilters).subscribe();
        }
      } else {
        for (const entry of x) {
          const tmpMap = new Map();
          this.domainMatFilters.set(entry.DomainName, tmpMap);
          tmpMap.set('B', entry.B);
          tmpMap.set('E', entry.E);
          tmpMap.set('Int', entry.Int);
          tmpMap.set('A', entry.A);
          tmpMap.set('Inn', entry.Inn);
        }
      }      
    });
  }

  /**
   * 
   */
  resetBandS(irp: number) {
    this.acetFilterSvc.getACETDomains().subscribe((domains: ACETDomain) => {
      this.domains = domains;
      this.domainMatFilters = new Map();
      this.getDefaultBand(irp);
      this.acetFilterSvc.saveFilters(this.domainMatFilters).subscribe();
    });
  }

  /**
   * 
   */
  getDefaultBand(irp: number) {
    const bands = this.getStairstepOrig(irp);
    const dmf = this.domainMatFilters;

    this.domains.forEach((d: Domain) => {
      dmf.set(d.DisplayText, new Map());
      dmf.get(d.DisplayText).set('B', bands.includes('B'));
      dmf.get(d.DisplayText).set('E', bands.includes('E'));
      dmf.get(d.DisplayText).set('Int', bands.includes('Int'));
      dmf.get(d.DisplayText).set('A', bands.includes('A'));
      dmf.get(d.DisplayText).set('Inn', bands.includes('Inn'));

      // bottom fill
      let belowBand = true;
      const i = this.domainMatFilters.get(d.DisplayText).entries();
      let e = i.next();
      while (!e.done && belowBand) {
        if (e.value[1]) {
          belowBand = false;
        } else {
          dmf.get(d.DisplayText).set(e.value[0], true);
        }
        e = i.next();
      }
    });
  }

  /**
   *
   */
  isDefaultMatLevel(mat: string) {
    const stairstepOrig = this.getStairstepOrig(this.overallIRP);
    if (!!stairstepOrig) {
      return stairstepOrig.includes(mat);
    }
    return false;
  }

  /**
   * Returns the maturity levels applicable to the overall IRP,
   * based on the stairstep graph in the NCUA Guide.
   */
  getStairstepOrig(irp: number): string[] {
    switch (irp) {
      case 0:
        return [];
      case 1:
        return ['B', 'E'];
      case 2:
        return ['B', 'E', 'Int'];
      case 3:
        return ['E', 'Int', 'A'];
      case 4:
        return ['Int', 'A', 'Inn'];
      case 5:
        return ['A', 'Inn'];
    }
  }

  /**
   * Returns the maturity levels applicable to the overall IRP,
   * based on the proposed 'grounded' stairstep graph.
   */
  getStairstepNew(irp: number): string[] {
    switch (irp) {
      case 0:
        return [];
      case 1:
        return ['B'];
      case 2:
        return ['B', 'E'];
      case 3:
        return ['B', 'E', 'Int'];
      case 4:
        return ['B', 'E', 'Int', 'A'];
      case 5:
        return ['B', 'E', 'Int', 'A', 'Inn'];
    }
  }

  /**
   * Indicates whether a certain filter is set to 'on'
   */
  isDomainMatFilterSet(domainName: string, mat: string) {
    if (!this.domainMatFilters.get(domainName)) {
      return false;
    }

    return this.domainMatFilters.get(domainName).get(mat);
  }

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
}
