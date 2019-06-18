import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AcetDashboard } from '../../../models/acet-dashboard.model';
import { AssessmentService } from '../../../services/assessment.service';
import { Navigation2Service } from '../../../services/navigation2.service';
import { ACETService } from '../../../services/acet.service';
import { QuestionsService } from '../../../services/questions.service';

@Component({
  selector: 'app-irp-summary',
  templateUrl: './irp-summary.component.html'
})
export class IrpSummaryComponent implements OnInit {

  acetDashboard: AcetDashboard;

  overrideLabel: string;

  constructor(private router: Router,
      public assessSvc: AssessmentService,
      public navSvc2: Navigation2Service,
      public acetSvc: ACETService,
      private questionsSvc: QuestionsService
  ) { }

  ngOnInit() {
      this.loadDashboard();
  }

  loadDashboard() {
      this.acetSvc.getAcetDashboard().subscribe(
          (data: AcetDashboard) => {
              this.acetDashboard = data;

              for (let i = 0; i < this.acetDashboard.IRPs.length; i++) {
                  this.acetDashboard.IRPs[i].Comment = this.acetSvc.interpretRiskLevel(this.acetDashboard.IRPs[i].RiskLevel);
              }

              this.overrideLabel = this.acetSvc.interpretRiskLevel(this.acetDashboard.SumRiskLevel);
          },
          error => {
              console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
              console.log('Error getting all documents: ' + (<Error>error).stack);
          });
  }

  changeInfoIrp(){
      this.questionsSvc.resetBandS(this.acetDashboard.Override);
      this.changeInfo();
  }

  changeInfo() {
      if (this.acetDashboard.Override === 0) {
          this.acetDashboard.OverrideReason = '';
      }
      
      this.acetSvc.postSelection(this.acetDashboard).subscribe((data:any)=>{
          this.loadDashboard();
      },
      error => {
          console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
          console.log('Error getting all documents: ' + (<Error>error).stack);
      });
  }

}
