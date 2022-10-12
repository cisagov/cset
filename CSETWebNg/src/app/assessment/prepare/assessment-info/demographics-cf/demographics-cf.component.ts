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
import { Demographic } from '../../../../models/assessment-info.model';
import { DemographicCf, DemographicsAssetValue, Sector, Subsector } from '../../../../models/demographics-cf.model';
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
  subsectorList: Subsector[];

  scopeList: any[];
  employeesList: any[];
  customersList: any[];
  cioList: any[];
  cisoList: any[];
  trainingList: any[];

  /**
   * This is the model that contains the current answers
   */
  demographicData: DemographicCf = {};


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
  }

  /**
   * 
   */
  getSubsectors(sectorId: number) {
    this.demoSvc.getSubsectorCf(sectorId).subscribe((data) => {
      //this.subsectorList = data;

      //this.subsectorList.push('sub1');
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
    this.demoSvc.updateDemographic(this.demographicData);
  }


  /**
   * Called when 'select all' or 'select none' is clicked
   * at the state level.
   */
  selectAllCounties(s: boolean) {
    this.listGeoAreas.forEach(x => {
      x.selected = s;
    });
    this.listCounties.forEach(x => {
      x.selected = s;
    });

    this.buildMetros();
  }

  /**
   * 
   */
  toggleGeoArea(a) {
    a.selected = !a.selected;

    a.counties?.forEach(c => {
      const c1 = this.listCounties.find(x => x.name == c);
      if (!!c1) {
        c1.selected = a.selected;
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
      if (this.listCounties.some(c => (c.name == m.county || m.counties?.includes(c.name)) && c.selected)) {
        this.listVisibleMetros.push(m);
      }
    });
  }


  listGeoAreas = [
    {
      selected: false, name: 'Northwest Florida', code: 'nw', counties: [
        'Escambia', 'Santa Rosa', 'Okaloosa', 'Walton', 'Holmes', 'Washington', 'Jackson', 'Calhoun',
        'Gulf, Bay'
      ]
    },
    { selected: false, name: 'North Central Florida', code: 'nc' },
    { selected: false, name: 'Northeast Florida', code: 'ne' },
    { selected: false, name: 'Central West Florida ', code: 'cw' },
    { selected: false, name: 'Central East Florida', code: 'ce' },
    { selected: false, name: 'Southwest Florida', code: 'sw' },
    { selected: false, name: 'Southeast Florida', code: 'se', counties: [
      'Palm Beach', 'Broward', 'Miami-Dade', 'Monroe'
    ] }
  ];



  listCounties = [
    { selected: false, name: 'Alachua', code: 'sw' },
    { selected: false, name: 'Baker', code: 'sw' },
    { selected: false, name: 'Bay', code: 'sw' },
    { selected: false, name: 'Bradford', code: 'sw' },
    { selected: false, name: 'Brevard', code: 'sw' },
    { selected: false, name: 'Broward', code: 'sw' },
    { selected: false, name: 'Calhoun', code: 'sw' },
    { selected: false, name: 'Charlotte', code: 'sw' },
    { selected: false, name: 'Citrus', code: 'sw' },
    { selected: false, name: 'Clay', code: 'sw' },
    { selected: false, name: 'Collier', code: 'sw' },
    { selected: false, name: 'Columbia', code: 'sw' },
    { selected: false, name: 'DeSoto', code: 'sw' },
    { selected: false, name: 'Dixie', code: 'sw' },
    { selected: false, name: 'Duval', code: 'sw' },
    { selected: false, name: 'Escambia', code: 'sw' },
    { selected: false, name: 'Flagler', code: 'sw' },
    { selected: false, name: 'Franklin', code: 'sw' },
    { selected: false, name: 'Gadsden', code: 'sw' },
    { selected: false, name: 'Gilchrist', code: 'sw' },
    { selected: false, name: 'Glades', code: 'sw' },
    { selected: false, name: 'Gulf', code: 'sw' },
    { selected: false, name: 'Hamilton', code: 'sw' },
    { selected: false, name: 'Hardee', code: 'sw' },
    { selected: false, name: 'Hendry', code: 'sw' },
    { selected: false, name: 'Hernando', code: 'sw' },
    { selected: false, name: 'Highlands', code: 'sw' },
    { selected: false, name: 'Hillsborough', code: 'sw' },
    { selected: false, name: 'Holmes', code: 'sw' },
    { selected: false, name: 'Indian River', code: 'sw' },
    { selected: false, name: 'Jackson', code: 'sw' },
    { selected: false, name: 'Jefferson', code: 'sw' },
    { selected: false, name: 'Lafayette', code: 'sw' },
    { selected: false, name: 'Lake', code: 'sw' },
    { selected: false, name: 'Lee', code: 'sw' },
    { selected: false, name: 'Leon', code: 'sw' },
    { selected: false, name: 'Levy', code: 'sw' },
    { selected: false, name: 'Liberty', code: 'sw' },
    { selected: false, name: 'Madison', code: 'sw' },
    { selected: false, name: 'Manatee', code: 'sw' },
    { selected: false, name: 'Marion', code: 'sw' },
    { selected: false, name: 'Martin', code: 'sw' },
    { selected: false, name: 'Miami-Dade', code: 'sw' },
    { selected: false, name: 'Monroe', code: 'sw' },
    { selected: false, name: 'Nassau', code: 'sw' },
    { selected: false, name: 'Okaloosa', code: 'sw' },
    { selected: false, name: 'Okeechobee', code: 'sw' },
    { selected: false, name: 'Orange', code: 'sw' },
    { selected: false, name: 'Osceola', code: 'sw' },
    { selected: false, name: 'Palm Beach', code: 'sw' },
    { selected: false, name: 'Pasco', code: 'sw' },
    { selected: false, name: 'Pinellas', code: 'sw' },
    { selected: false, name: 'Polk', code: 'sw' },
    { selected: false, name: 'Putnam', code: 'sw' },
    { selected: false, name: 'Santa Rosa', code: 'sw' },
    { selected: false, name: 'Sarasota', code: 'sw' },
    { selected: false, name: 'Seminole', code: 'sw' },
    { selected: false, name: 'St. Johns', code: 'sw' },
    { selected: false, name: 'St. Lucie', code: 'sw' },
    { selected: false, name: 'Sumter', code: 'sw' },
    { selected: false, name: 'Suwannee', code: 'sw' },
    { selected: false, name: 'Taylor', code: 'sw' },
    { selected: false, name: 'Union', code: 'sw' },
    { selected: false, name: 'Volusia', code: 'sw' },
    { selected: false, name: 'Wakulla', code: 'sw' },
    { selected: false, name: 'Walton', code: 'sw' },
    { selected: false, name: 'Washington', code: 'sw' }
  ];

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
