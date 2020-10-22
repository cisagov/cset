import { Component, Host, OnInit } from '@angular/core';
import { NavigationService } from '../../../../services/navigation.service';
import { AssessmentService } from '../../../../services/assessment.service';
import { MaturityService } from '../../../../services/maturity.service';
import { MaturityLevel } from '../../../../models/maturity.model';
import { ActivatedRoute } from '@angular/router';
import { AppComponent } from '../../../../app.component';

@Component({
  selector: 'app-cmmc-levels',
  templateUrl: './cmmc-levels.component.html'
})
export class CmmcLevelsComponent implements OnInit {

  selectedLevel: MaturityLevel = { name: "zero", value: 0 };

  constructor(
    private assessSvc: AssessmentService,
    public maturitySvc: MaturityService,
    public navSvc: NavigationService, 
    private activatedRoute: ActivatedRoute
  ) { 
    this.activatedRoute.data.subscribe(()=>{
      this.selectedLevel.value = this.assessSvc.assessment.MaturityTargetLevel;
    })
  }

  /**
   * 
   */
  ngOnInit() {
    
    
  }

  /**
   * 
   * @param newLevel 
   */
  saveLevel(newLevel) {
    this.maturitySvc.levels.forEach(l => {
      if (l.value === newLevel) {
        this.selectedLevel = l;
      }
    });

    this.maturitySvc.saveLevel(this.selectedLevel.value).subscribe(() => {
      return;
    });
  }

}
