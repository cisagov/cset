import { Component, OnInit } from '@angular/core';
import { DemographicIodService } from '../../../../services/demographic-iod.service';

@Component({
  selector: 'app-demographics-iod',
  templateUrl: './demographics-iod.component.html',
  styleUrls: ['./demographics-iod.component.scss']
})
export class DemographicsIodComponent implements OnInit {

  /**
   * The principal model for this page
   */
  demographicData: any = {};


  employeeNumsOrg: any[];
  employeeNumsBizUnit: any[];
  orgTypes: any[];


  regTypes: any[] = [];
  shareOrgs: any[] = [];

  constructor(
    public demoSvc: DemographicIodService
  ) {

  }

  /**
   * 
   */
  ngOnInit() {
    this.demoSvc.getDemographics().subscribe((data: any) => {
      this.demographicData = data;
      //console.log(data);
    });

  }


  changeValue(evt: any) {

  }

  changeOrgType(evt: any) {
    this.demographicData.organizationType = evt.target.value;
    this.updateDemographics();
  }

  changeOrgName(evt: any) {

  }

  changeBusinessUnit(evt: any) {

  }

  updateDemographics() {
    
  }


}
