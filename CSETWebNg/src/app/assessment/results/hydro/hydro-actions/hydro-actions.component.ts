import { Component, Input, OnInit } from '@angular/core';
import { ReportService } from '../../../../services/report.service';
import { AssessmentService } from '../../../../services/assessment.service';
import { QuestionsService } from '../../../../services/questions.service';
import { CisService } from '../../../../services/cis.service';
import { HydroService } from '../../../../services/hydro.service';
import { MaturityService } from '../../../../services/maturity.service';

@Component({
  selector: 'app-hydro-actions',
  templateUrl: './hydro-actions.component.html',
  styleUrls: ['./hydro-actions.component.scss']
})
export class HydroActionsComponent implements OnInit {

  actionItemData: any[] = [];
  unsortedActionItemData: any[] = [];
  progressTotalsMap: Map<String, number[]> = new Map<String, number[]>();

  loading: boolean = true;

  domainExpandMap: Map<String, boolean> = new Map<String, boolean>();
  progressLevels: any[] = [];

  domainGroupNames: string[] = ['Management', 'Site and Service Control Security', 'Critical Operations', 'Dependencies'];
  percentStyleArray: string[] =['not-started-percent', 'complete-percent'];

  constructor(
    public reportSvc: ReportService,
    public assessSvc: AssessmentService,
    public questionsSvc: QuestionsService,
    public maturitySvc: MaturityService,
    public cisSvc: CisService,
    public hydroSvc: HydroService
  ) {}

  ngOnInit() {
    this.hydroSvc.getProgressText().subscribe(
      (r: any) => {
        console.log(r)
        this.progressLevels = r;
      }
    )

    this.reportSvc.getHydroActionItems().subscribe(
      (r: any) => {
        let initialActionItemData = r;
        console.log(initialActionItemData)

        for (let i = 0; i < initialActionItemData.length; i++) {
          let seq = initialActionItemData[i].domainSequence;
          let newSeq = i;

          if (newSeq+1 == seq) {
            let currProgressTotals = [0,0,0,0];

            if (this.progressTotalsMap.has(initialActionItemData[i].domainName)) {
              currProgressTotals = this.progressTotalsMap.get(initialActionItemData[i].domainName);
            }
           
            for (let item of initialActionItemData[i].actionsQuestions) {
              currProgressTotals[item.actionData.progress_Id - 1]++;
            }
            this.progressTotalsMap.set(initialActionItemData[i].domainName, currProgressTotals);
            
            this.actionItemData.push(initialActionItemData[i]);
          } 

          else {
            while (newSeq < seq && newSeq < this.domainGroupNames.length) {
              this.progressTotalsMap.set(initialActionItemData[newSeq].domainName, [0,0,0,0]);

              this.actionItemData.push({
                'actionsQuestions': [],
                'domainName': this.domainGroupNames[newSeq],
                'domainSequence': ++newSeq
              });
            }
          }
        }

        while (this.actionItemData.length < this.domainGroupNames.length) {
          this.actionItemData.push({
            'actionsQuestions': [],
            'domainName': this.domainGroupNames[this.actionItemData.length],
            'domainSequence': this.actionItemData.length + 1
          });

          this.progressTotalsMap.set(this.domainGroupNames[this.actionItemData.length-1], [0,0,0,0]);
        }

        this.sortBySeverity();
        this.loading = false;
        console.log(this.progressTotalsMap)
        console.log(this.actionItemData)
      }
    )
    
  }

  toggleCategory(catName: string) {
    let currValue = false;
    if (this.domainExpandMap.has(catName)) {
      currValue = this.domainExpandMap.get(catName);
    }
    for (let i = 0; i < this.domainGroupNames.length; i++) {
      this.domainExpandMap.set(this.domainGroupNames[i], false);
    }
    if (this.domainExpandMap.has(catName)) {
      this.domainExpandMap.set(catName, !currValue);
    }

    // this.scrollToElement('domain-' + catName);
  }

  impactTranslator(impact: number) {
    if (impact == 1) {
      return 'High';
    }
    if (impact == 2) {
      return 'Medium';
    }
    if (impact == 3) {
      return 'Low';
    }
  }

  sortBySeverity() {
    for (let domain of this.actionItemData) {
      domain.actionsQuestions.sort((a, b) => (a.action.severity < b.action.severity ? -1 : 1))      
    }
  }

  getCompletionPercent(domainName: string) {
    let totals = this.progressTotalsMap.get(domainName);
    
    let totalActionItems = totals[0] + totals[1] + totals[2] + totals[3];

    if(totalActionItems == 0) {
      return 0;
    }
    return ((totals[3] / totalActionItems) * 100).toFixed(0);
  }

}
