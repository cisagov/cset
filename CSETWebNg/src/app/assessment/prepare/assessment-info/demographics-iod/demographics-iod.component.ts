import { Component, OnInit } from '@angular/core';
import { DemographicIodService } from '../../../../services/demographic-iod.service';
import { DemographicsIod } from '../../../../models/demographics-iod.model';

@Component({
  selector: 'app-demographics-iod',
  templateUrl: './demographics-iod.component.html',
  styleUrls: ['./demographics-iod.component.scss']
})
export class DemographicsIodComponent implements OnInit {

  /**
   * The principal model for this page
   */
  demographicData: DemographicsIod = {};



  employeeNumsOrg: any[];
  employeeNumsBizUnit: any[];
  orgTypes: any[];




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
    });

  }

  /**
   *
   */
  onChangeSector(evt: any) {
    var sectorId = evt.target.value;
    this.demographicData.sector = sectorId;
    this.demographicData.subsector = '';
    this.updateDemographics();

    this.demoSvc.getSubsectors(sectorId).subscribe((data: any[]) => {
      this.demographicData.listSubsectors = data;
    });
  }

  changeUsesStandard(val: boolean) {
    this.demographicData.usesStandard = val;
    this.updateDemographics();
  }

  setRequireComply(val: boolean) {
    this.demographicData.requiredToComply = val;
    this.updateDemographics();
  }

  changeRegType1(o: any, evt: any) {
    this.demographicData.regulationType1 = o.optionValue;
    this.updateDemographics();
  }

  changeRegType2(o: any, evt: any) {
    this.demographicData.regulationType2 = o.optionValue;
    this.updateDemographics();
  }

  changeShareOrg(org: any, evt: any) {
    // see which orgs are selected
    console.log('changeShareOrg');
    console.log(org);

    org.selected = (evt.target.value == 'on');
    this.demographicData.shareOrgs[org.optionValue] = org.selected;
    this.updateDemographics();
  }



  update(event: any) {
    this.updateDemographics();
  }

  updateDemographics() {
    this.demoSvc.updateDemographic(this.demographicData);
  }
}
