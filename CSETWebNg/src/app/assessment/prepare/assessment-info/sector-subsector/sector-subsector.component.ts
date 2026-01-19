import { Component, Input, OnInit } from '@angular/core';
import { DemographicIodService } from '../../../../services/demographic-iod.service';
import { AssessmentService } from '../../../../services/assessment.service';
import { DemographicsIod, SectorThing } from '../../../../models/demographics-iod.model';

@Component({
  selector: 'app-sector-subsector',
  standalone: false,
  templateUrl: './sector-subsector.component.html',
  styleUrl: './sector-subsector.component.scss',
})
export class SectorSubsectorComponent implements OnInit {

  @Input()
  demographicData: DemographicsIod;


  list: SectorThing[];


  constructor(
    public assessSvc: AssessmentService,
    public demoSvc: DemographicIodService
  ) {
    if (this.demographicData.sectors.length == 0) {
      this.demographicData.sectors = [];
      this.demographicData.sectors.push({
        sector: 17,
        subsector: 124
      });
    }
  }


  ngOnInit(): void {

    console.log(this.demographicData.sectors);
  }


  /**
   *
   */
  onChangeSector() {
    if (!this.demographicData.sector) {
      this.demographicData.listSubsectors = [];
      this.demographicData.subsector = null;
    } else {
      this.demoSvc.getSubsectors(this.demographicData.sector).subscribe((data: any[]) => {
        this.demographicData.listSubsectors = data;
      });
    }
    this.assessSvc.assessment.sectorId = this.demographicData.sector;
    this.assessSvc.assessment.ssgSectorIds = this.demographicData.ssgSectors;


    // TODO -- emit some things
    //this.assessSvc.assessmentStateChanged$.next(this.c.NAV_REFRESH_TREE_ONLY);
    //this.updateDemographics();
  }

  update(evt) {

  }



}
