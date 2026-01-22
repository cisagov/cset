import { Component, Input, OnChanges, OnInit, SimpleChanges } from '@angular/core';
import { DemographicIodService } from '../../../../services/demographic-iod.service';
import { AssessmentService } from '../../../../services/assessment.service';
import { DemographicsIod, SectorThing } from '../../../../models/demographics-iod.model';

@Component({
  selector: 'app-sector-subsector',
  standalone: false,
  templateUrl: './sector-subsector.component.html',
  styleUrl: './sector-subsector.component.scss',
})
export class SectorSubsectorComponent implements OnInit, OnChanges {

  @Input()
  demographicData: DemographicsIod;



  list: SectorThing[];


  constructor(
    public assessSvc: AssessmentService,
    public demoSvc: DemographicIodService
  ) {  }


  ngOnInit(): void {
  }

  /**
   * 
   */
  ngOnChanges(changes: SimpleChanges): void {
    this.list = this.demographicData.sectorSubsectors;
  }


  /**
   *
   */
  onChangeSector(evt, item) {
    console.log('onChangeSector: ', evt, item);

    if (!item.sectorId) {
      item.listSubsectors = [];
      item.subsectorId = null;
    } else {
      this.demoSvc.getSubsectors(item.sectorId).subscribe((data: any[]) => {
        console.log('getSubsectors from API: ', data);
        item.listSubsectors = data;
      });
    }

    //this.assessSvc.assessment.sectorId = this.demographicData.sector;
    //this.assessSvc.assessment.ssgSectorIds = this.demographicData.ssgSectors;


    // TODO -- emit some things
    //this.assessSvc.assessmentStateChanged$.next(this.c.NAV_REFRESH_TREE_ONLY);
    //this.updateDemographics();
  }

  /**
   * 
   */
  onChangeSubsector(evt, item) {

    console.log('onChangeSubsector:', evt, item);
  }
}
