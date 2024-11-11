import { Component } from '@angular/core';
import { NavigationService } from '../../../../services/navigation/navigation.service';
import { MaturityService } from '../../../../services/maturity.service';
import { AssessmentService } from '../../../../services/assessment.service';
import { MaturityLevel } from '../../../../models/maturity.model';

@Component({
  selector: 'app-cmmc2-levels',
  templateUrl: './cmmc2-levels.component.html',
  styleUrls: ['./cmmc2-levels.component.scss']
})
export class Cmmc2LevelsComponent {

  selectedLevel: number;

  constructor (
    public assessSvc: AssessmentService,
    public maturitySvc: MaturityService,
    public navSvc: NavigationService
  ) { }


  /**
   * 
   */
  ngOnInit() {
    if (this.assessSvc.assessment == null) {
      this.assessSvc.getAssessmentDetail().subscribe((data: any) => {
        this.assessSvc.assessment = data;
        this.selectedLevel = this.assessSvc.assessment.maturityModel.maturityTargetLevel;
      });
    } else {
      this.selectedLevel = +this.assessSvc.assessment.maturityModel.maturityTargetLevel;
    }
  }

  /**
   * 
   */
  saveLevel(selection: number) {
    this.selectedLevel = selection;

    this.maturitySvc.saveLevel(selection).subscribe(() => {
      // refresh Prepare section of the sidenav
      this.navSvc.buildTree();
      return;
    });
  }
}
