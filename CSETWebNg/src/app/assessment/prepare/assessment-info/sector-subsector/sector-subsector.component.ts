////////////////////////////////
//
//   Copyright 2025 Battelle Energy Alliance, LLC
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
import { Component, Input, OnChanges, OnInit, SimpleChanges } from '@angular/core';
import { DemographicIodService } from '../../../../services/demographic-iod.service';
import { AssessmentService } from '../../../../services/assessment.service';
import { DemographicsIod } from '../../../../models/demographics-iod.model';
import { SectorSub } from '../../../../models/demographics-extended.model';
import { ConstantsService } from '../../../../services/constants.service';
import { CompletionService } from '../../../../services/completion.service';
import { SectorChangeResponse } from '../../../../models/questions.model';


@Component({
  selector: 'app-sector-subsector',
  standalone: false,
  templateUrl: './sector-subsector.component.html',
  styleUrl: './sector-subsector.component.scss'
})
export class SectorSubsectorComponent implements OnInit, OnChanges {

  @Input()
  demographicData: DemographicsIod;

  /**
   * Switch to turn on "multi sector" support; multiple sector displays, add and delete links, etc.
   */
  @Input()
  multi: boolean = true;

  sectorList: SectorSub[];


  constructor(
    public assessSvc: AssessmentService,
    public demoSvc: DemographicIodService,
    public completionSvc: CompletionService,
    private c: ConstantsService
  ) { }


  ngOnInit(): void {
  }

  /**
   * 
   */
  ngOnChanges(changes: SimpleChanges): void {
    this.sectorList = this.demographicData.sectorSubsectors;

    this.demoSvc.demographicUpdateCompleted$.next();
  }

  /**
   *
   */
  onChangeSector(evt, item) {
    // update the model 
    const target = this.demographicData.sectorSubsectors.find(x => x.sequence == item.sequence);
    target.sectorId = item.sectorId;
    target.subsectorId = item.subsectorId;


    // post the sector model to update the back end
    this.demoSvc.saveSector(item).subscribe((response: SectorChangeResponse) => {
      item.subsectorList = response.subsectors;

      if (!item.subsectorList.some(x => x.optionValue == item.subsectorId)) {
        target.subsectorId = null;
      }

      this.refreshCompletion(response);
    
      this.assessSvc.assessment.sectorSubsectors = [...this.demographicData.sectorSubsectors];

      this.assessSvc.assessmentStateChanged$.next(this.c.NAV_REFRESH_TREE_ONLY);
    });
  }

  /**
   * 
   */
  onAddSector() {
    // get the max current sequence
    const seqs = this.assessSvc.assessment.sectorSubsectors.map(x => x.sequence);
    const maxSeq = Math.max(...seqs);

    const newSectorSubsector: SectorSub = {
      sectorId: null,
      subsectorId: null,
      sequence: maxSeq + 1
    };
    this.demographicData.sectorSubsectors.push(newSectorSubsector);
    this.assessSvc.assessment.sectorSubsectors = [...this.demographicData.sectorSubsectors];

    this.assessSvc.assessmentStateChanged$.next(this.c.NAV_REFRESH_TREE_ONLY);
  }

  /**
   * 
   */
  onRemoveSector(evt, item) {
    this.demoSvc.removeSector(item).subscribe((response: SectorChangeResponse) => {
      
      const idd = this.demographicData.sectorSubsectors.findIndex(i => i.sequence == item.sequence);
      if (idd !== -1) {
        this.demographicData.sectorSubsectors.splice(idd, 1);
      }

      this.refreshCompletion(response);

      this.assessSvc.assessment.sectorSubsectors = [...this.demographicData.sectorSubsectors];

      this.assessSvc.assessmentStateChanged$.next(this.c.NAV_REFRESH_TREE_ONLY);
    });
  }

  /**
   * refresh the questions counts to drive the progress bar
   */
  refreshCompletion(response: SectorChangeResponse) {
      if (response?.completedCount !== undefined) {
        const totalCount =
          (response.totalMaturityQuestionsCount || 0) +
          (response.totalDiagramQuestionsCount || 0) +
          (response.totalStandardQuestionsCount || 0);
          
        this.assessSvc.completionRefreshRequested$.next({
          completedCount: response.completedCount,
          totalCount: totalCount
        });
      }
  }
}
