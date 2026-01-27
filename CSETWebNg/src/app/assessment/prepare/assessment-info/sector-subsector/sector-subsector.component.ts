import { Component, Input, OnChanges, OnInit, SimpleChanges } from '@angular/core';
import { DemographicIodService } from '../../../../services/demographic-iod.service';
import { AssessmentService } from '../../../../services/assessment.service';
import { DemographicsIod, SectorThing } from '../../../../models/demographics-iod.model';
import { ConstantsService } from '../../../../services/constants.service';

@Component({
  selector: 'app-sector-subsector',
  standalone: false,
  templateUrl: './sector-subsector.component.html',
  styleUrl: './sector-subsector.component.scss',
})
export class SectorSubsectorComponent implements OnInit, OnChanges {

  @Input()
  demographicData: DemographicsIod;

  /**
   * Switch to turn on "multi sector" support.
   */
  @Input()
  multi: boolean = true;

  sectorList: SectorThing[];


  constructor(
    public assessSvc: AssessmentService,
    public demoSvc: DemographicIodService,
    private c: ConstantsService
  ) { }


  ngOnInit(): void {
  }

  /**
   * 
   */
  ngOnChanges(changes: SimpleChanges): void {
    this.sectorList = this.demographicData.sectorSubsectors;
  }


  /**
   *
   */
  onChangeSector(evt, item) {
    // update the model 
    const target = this.assessSvc.assessment.sectorSubsectors.find(x => x.sequence == item.sequence);
    target.sectorId = item.sectorId;
    target.subsectorId = item.subsectorId;


    // post the sector model to update the back end
    this.demoSvc.saveSector(item).subscribe(subsectorList => {
      item.subsectorList = subsectorList;

      if (!item.subsectorList.some(x => x.optionValue == item.subsectorId)) {
        target.subsectorId = null;
      }

      // TODO -- emit some things
      this.assessSvc.assessmentStateChanged$.next(this.c.NAV_REFRESH_TREE_ONLY);

      console.log('666');
      console.log(item);
      console.log(target);
    });
  }

  onAddSector() {

  }

  onRemoveSector() {

  }
}
