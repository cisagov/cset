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
import { Component, OnInit } from '@angular/core';
import { MatDialog, MatDialogConfig } from '@angular/material/dialog';
import { SectorHelpComponent } from '../../../../dialogs/sector-help/sector-help.component';
import { Demographic } from '../../../../models/assessment-info.model';
import { County, ExtendedDemographics, ListItem, Region, Sector, Subsector, Geographics } from '../../../../models/demographics-extended.model';
import { AssessmentService } from '../../../../services/assessment.service';
import { ConfigService } from '../../../../services/config.service';
import { DemographicExtendedService } from '../../../../services/demographic-extended.service';
import { NavigationService } from '../../../../services/navigation/navigation.service';


@Component({
  selector: 'app-demographics-extended',
  templateUrl: './demographics-extended.component.html'
})
export class DemographicsExtendedComponent implements OnInit {

  sectorList: Sector[];
  subSectorList: Subsector[];

  regionList: Region[];
  countyList: County[];
  metroList: any[];
  visibleMetroList = [];

  employeeRanges: ListItem[];
  customerRanges: ListItem[];
  geoScopeList: ListItem[];
  cioList: any[];
  cisoList: any[];
  trainingList: any[];
  radioNo: any;

  /**
   * This is the model that contains the current answers
   */
  demographicData: ExtendedDemographics = {};
  geoGraphics: any;


  /**
   * 
   */
  constructor(
    private demoSvc: DemographicExtendedService,
    public assessSvc: AssessmentService,
    public configSvc: ConfigService,
    private navSvc: NavigationService,
    private dialog: MatDialog
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.demoSvc.getAllSectors().subscribe(
      (data: Sector[]) => {
        this.sectorList = data;
      },
      error => {
        console.log('Error Getting all sectors: ' + (<Error>error).name + (<Error>error).message);
        console.log('Error Getting all sectors (cont): ' + (<Error>error).stack);
      });

    this.demoSvc.getRegions('FL').subscribe((data: any) => {
      this.regionList = data;

      this.countyList = [];
      this.regionList.forEach(r => {
        this.countyList.push(...r.counties);
      });
      this.countyList.sort((a, b) => {
        if (a.name < b.name) { return -1; }
        if (a.name > b.name) { return 1; }
        return 0;
      });
    });

    this.demoSvc.getMetros('FL').subscribe((data: any) => {
      this.metroList = [];

      data.forEach(m => {
        const m1 = {
          selected: false,
          name: m.metropolitanAreaName,
          fips: m.metro_FIPS,
          counties: []
        };

        m.countY_METRO_AREA.forEach(e => {
          m1.counties.push(e.county_FIPS)
        });

        this.metroList.push(m1);
      });
    });


    this.demoSvc.getEmployeeRanges().subscribe((data: ListItem[]) => {
      this.employeeRanges = data;
    });

    this.demoSvc.getCustomerRanges().subscribe((data: ListItem[]) => {
      this.customerRanges = data;
    });

    this.demoSvc.getGeoScope().subscribe((data: ListItem[]) => {
      this.geoScopeList = data;
    });

    this.demoSvc.getCio().subscribe((data: ListItem[]) => {
      this.cioList = data;
    });

    this.demoSvc.getCiso().subscribe((data: ListItem[]) => {
      this.cisoList = data;
    });

    this.demoSvc.getTraining().subscribe((data: ListItem[]) => {
      this.trainingList = data;
    });

    this.getDemographics();

    setTimeout(() => {
      this.getGeographics();
    }, 1000);
  }

  /**
   * Get any existing answers for the page.
   */
  getDemographics() {
    this.demoSvc.getDemographics().subscribe(
      (data: Demographic) => {
        this.demographicData = data;
        // populate Subsector (industry) dropdown based on Sector
        this.getSubsectors(this.demographicData.sectorId, false);
        this.checkComplete();
      },
      error => console.log('Demographic load Error: ' + (<Error>error).message)
    );
  }

  /**
   * 
   */
  getGeographics() {
    this.demoSvc.getGeographics().subscribe(
      (data: any) => {
        this.geoGraphics = data;
        data.regions.forEach(x => {
          this.regionList.find(y => y.regionCode == x.regionCode).selected = true;
        });

        data.countyFips.forEach(x => {
          this.countyList.find(y => y.fips == x).selected = true;
        });

        data.metroFips.forEach(x => {
          this.metroList.find(y => y.fips == x).selected = true;
        });
        this.buildMetros();
        this.checkComplete();
      }
    );
  }

  /**
   * Get the subsector list for the specified sector.
   */
  getSubsectors(sectorId: number, clearSubsector: boolean) {
    if (!sectorId) {
      return;
    }

    if (clearSubsector) {
      this.demographicData.subSectorId = null;
    }

    this.updateDemographics();

    this.demoSvc.getSubsector(sectorId).subscribe((data: Subsector[]) => {
      this.subSectorList = data;
    });
  }

  /**
   * 
   */
  update(event: any) {
    this.updateDemographics();
  }
  /**
   * 
   */
  updateDemographics() {
    this.demoSvc.updateExtendedDemographics(this.demographicData);
    this.checkComplete();
  }

  checkComplete() {
    if (this.demoSvc.AreDemographicsComplete(this.demographicData, this.geoGraphics)) {
      this.navSvc.setNextEnabled(true);
    }
    else {
      this.navSvc.setNextEnabled(false);
    }
  }



  /**
   * Called when 'select all' or 'select none' is clicked
   * at the state level.
   */
  selectAllCounties(s: boolean) {
    this.regionList.forEach(x => {
      x.selected = s;
    });
    this.countyList.forEach(x => {
      x.selected = s;
    });

    this.buildMetros();
  }

  /**
   * 
   */
  toggleRegion(r) {
    r.selected = !r.selected;

    r.counties?.forEach(c => {
      const c1 = this.countyList.find(x => x.fips == c.fips);
      if (!!c1) {
        c1.selected = r.selected;
      }
    });

    this.buildMetros();
  }

  /**
   * 
   */
  toggleCounty(c) {
    c.selected = !c.selected;

    this.buildMetros();
  }

  /**
   * 
   */
  toggleMetro(m) {
    m.selected = !m.selected;
    this.saveGeoSelections();
  }

  /**
   * Builds the list of metro areas based on county selection
   */
  buildMetros() {
    this.visibleMetroList = [];

    this.metroList.forEach(m => {
      if (this.countyList.some(c => (m.counties?.includes(c.fips)) && c.selected)) {
        this.visibleMetroList.push(m);
      }
    });
    this.visibleMetroList.sort((a, b) => {
      if (a.name < b.name) { return -1; }
      if (a.name > b.name) { return 1; }
      return 0;
    });

    this.saveGeoSelections();
  }


  /**
   * 
   */
  saveGeoSelections() {
    const x: Geographics = {};

    x.regions = [];
    this.regionList.filter(x => x.selected).forEach(r => {
      x.regions.push({
        regionCode: r.regionCode,
        state: r.state
      });
    });

    x.countyFips = [];
    this.countyList.filter(x => x.selected).forEach(c => {
      x.countyFips.push(c.fips);
    });

    x.metroFips = [];
    this.visibleMetroList.filter(x => x.selected).forEach(m => {
      x.metroFips.push(m.fips);
    });

    this.demoSvc.persistGeographicSelections(x);
  }

  /**
   * Displays a dialog showing the help for sectors.
   */
  launchSectorHelp() {
    var config: MatDialogConfig = {
      data: this.sectorList
    };
    this.dialog.open(SectorHelpComponent, config);
  }

  setCyberRisk(value: string) {
    this.demographicData.cyberRiskService = value;
    this.updateDemographics();
  }

  setHb7055(value: string) {
    this.demographicData.hb7055 = value;
    if (value !== 'Y') {
      this.radioNo.value = '';
      this.demographicData.hb7055Party = '';
    }
    this.updateDemographics();
  }

  setHb7055Party(event) {
    this.demographicData.hb7055Party = event.target.value;
    this.updateDemographics();
  }
  getGrant():boolean{    
    return (this.demographicData.hb7055Grant == 'Y');
  }
  getGrantNo():boolean{
    return (this.demographicData.hb7055Grant == 'N');
  }
  sethb7055Grant(value: string) {
    this.demographicData.hb7055Grant = value;
    if (value != 'Y') {
      this.demographicData.hb7055Grant = '';      
    }    
    this.updateDemographics();

  }
  setInfrastructureItOt(value: string) {
    this.demographicData.infrastructureItOt = value;
    this.updateDemographics();
  }
}
