import { Component } from '@angular/core';
import { AssessmentService } from '../../../../services/assessment.service';
import { MaturityService } from '../../../../services/maturity.service';
import { NavigationService } from '../../../../services/navigation/navigation.service';

@Component({
  selector: 'app-cisa-vadr-levels',
  templateUrl: './cisa-vadr-levels.component.html',
  styleUrl: './cisa-vadr-levels.component.scss',
  standalone: false
})
export class CisaVadrLevelsComponent {

  selectedLevel: number;

  constructor(
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
