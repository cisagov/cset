////////////////////////////////
//
//   Copyright 2022 Battelle Energy Alliance, LLC
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
import { MatGridTileHeaderCssMatStyler } from '@angular/material/grid-list';
import { Demographic } from '../../../../models/assessment-info.model';
import { County, CustomerRange, ExtendedDemographics, EmployeeRange, ListItem, Region, Sector, Subsector } from '../../../../models/demographics-cf.model';
import { User } from '../../../../models/user.model';
import { AssessmentService } from '../../../../services/assessment.service';
import { ConfigService } from '../../../../services/config.service';
import { DemographicService } from '../../../../services/demographic.service';


@Component({
  selector: 'app-demographics-cf',
  templateUrl: './demographics-cf.component.html'
})
export class DemographicsCfComponent implements OnInit {

  sectorList: Sector[];
  subSectorList: Subsector[];

  regionList: Region[];
  countyList: County[];

  employeeRanges: ListItem[];
  customerRanges: ListItem[];
  geoScopeList: ListItem[];
  cioList: any[];
  cisoList: any[];
  trainingList: any[];

  /**
   * This is the model that contains the current answers
   */
  demographicData: ExtendedDemographics = {};


  /**
   * 
   */
  constructor(
    private demoSvc: DemographicService,
    public assessSvc: AssessmentService,
    public configSvc: ConfigService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.demoSvc.getAllSectorsCf().subscribe(
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
  }

  /**
   * Get any existing answers for the page.
   */
  getDemographics() {
    this.demoSvc.getDemographicCf().subscribe(
      (data: Demographic) => {
        this.demographicData = data;

        // populate Industry dropdown based on Sector
        //this.populateIndustryOptions(this.demographicData.sectorId);
      },
      error => console.log('Demographic load Error: ' + (<Error>error).message)
    );
  }



  /**
   * 
   */
  getSubsectors(sectorId: number) {
    if (!sectorId) {
      return;
    }

    this.updateDemographics();

    this.demoSvc.getSubsectorCf(sectorId).subscribe((data: Subsector[]) => {
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
    this.demographicData.subSectorId = null;
    console.log(this.demographicData);
    this.demoSvc.updateExtendedDemographics(this.demographicData);
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
  }

  /**
   * Builds the list of metro areas based on county selection
   */
  buildMetros() {
    this.listVisibleMetros = [];

    this.listMetros.forEach(m => {
      if (this.countyList.some(c => (c.name == m.county || m.counties?.includes(c.name)) && c.selected)) {
        this.listVisibleMetros.push(m);
      }
    });
  }


  listVisibleMetros = [];

  listMetros = [
    { selected: false, name: 'Jacksonville', county: 'Duval' },
    { selected: false, name: 'Miami', county: 'Miami-Dade' },
    { selected: false, name: 'Tampa', county: 'Hillsborough' },
    { selected: false, name: 'Orlando', county: 'Orange' },
    { selected: false, name: 'St. Petersburg', county: 'Pinellas' },
    { selected: false, name: 'Hialeah', county: 'Miami-Dade' },
    { selected: false, name: 'Port St. Lucie', county: 'St. Lucie' },
    { selected: false, name: 'Cape Coral', county: 'Lee' },
    { selected: false, name: 'Tallahassee', county: 'Leon' },
    { selected: false, name: 'Fort Lauderdale', county: 'Broward' },
    { selected: false, name: 'Pembroke Pines', county: 'Broward' },
    { selected: false, name: 'Hollywood', county: 'Broward' },
    { selected: false, name: 'Gainesville', county: 'Alachua' },
    { selected: false, name: 'Miramar', county: 'Broward' },
    { selected: false, name: 'Coral Springs', county: 'Broward' },
    { selected: false, name: 'Palm Bay', county: 'Brevard' },
    { selected: false, name: 'West Palm Beach', county: 'Palm Beach' },
    { selected: false, name: 'Leigh Acres', county: 'Lee' },
    { selected: false, name: 'Clearwater', county: 'Pinellas' },
    { selected: false, name: 'Brandon', county: 'Hillsborough' },
    { selected: false, name: 'Spring Hill', county: 'Hernando' },
    { selected: false, name: 'Lakeland', county: 'Polk' },
    { selected: false, name: 'Riverview', county: 'Hillsborough' },
    { selected: false, name: 'Pompano Beach', county: 'Broward' },
    { selected: false, name: 'Miami Gardens', county: 'Miami-Dade' },
    { selected: false, name: 'Davie', county: 'Broward' },
    { selected: false, name: 'Bocas Raton', county: 'Palm Beach' },
    { selected: false, name: 'Sunrise', county: 'Broward' },
    { selected: false, name: 'Deltona', county: 'Volusia' },
    { selected: false, name: 'Alafaya', county: 'Orange' },
    { selected: false, name: 'Plantation', county: 'Broward' },
    { selected: false, name: 'Palm Coast', county: 'Flagler' },
    { selected: false, name: 'Fort Myers', county: 'Lee' },
    { selected: false, name: 'Deerfield Beach', county: 'Broward' },
    { selected: false, name: 'Town ‘n’ Country', county: 'Hillsborough' },
    { selected: false, name: 'Melbourne', county: 'Brevard' },
    { selected: false, name: 'The Villages', county: 'Sumter' },
    { selected: false, name: 'Largo', county: 'Pinellas' },
    { selected: false, name: 'Kissimmee', county: 'Osceola' },
    { selected: false, name: 'Boynton Beach', county: 'Palm Beach' },
    { selected: false, name: 'Miami Beach', county: 'Miami-Dade' },
    { selected: false, name: 'Doral', county: 'Miami-Dade' },
    { selected: false, name: 'Kendall', county: 'Miami-Dade' },
    { selected: false, name: 'North Port', county: 'Sarasota' },
    { selected: false, name: 'Lauderhill', county: 'Broward' },
    { selected: false, name: 'Daytona Beach', county: 'Volusia' },
    { selected: false, name: 'Tamarac', county: 'Broward' },
    { selected: false, name: 'Poinciana', counties: ['Osceola', 'Polk'] },
    { selected: false, name: 'Westley Chapel', county: 'Pasco' }
  ];

}
