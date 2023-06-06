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

  loading: boolean = true;

  domainExpandMap: Map<String, boolean> = new Map<String, boolean>();

  domainGroupNames: string[] = ['Management', 'Site and Service Control Security', 'Critical Operations', 'Dependencies'];

  constructor(
    public reportSvc: ReportService,
    public assessSvc: AssessmentService,
    public questionsSvc: QuestionsService,
    public maturitySvc: MaturityService,
    public cisSvc: CisService,
    public hydroSvc: HydroService
  ) {}

  ngOnInit() {
    this.reportSvc.getHydroActionItems().subscribe(
      (r: any) => {
        let initialActionItemData = r;

        for (let i = 0; i < initialActionItemData.length; i++) {
          let seq = initialActionItemData[i].domainSequence;
          let newSeq = i;

          if (newSeq+1 == seq) {
            this.actionItemData.push(initialActionItemData[i]);
          } 

          else {
            while (newSeq < seq && newSeq < this.domainGroupNames.length) {
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
        }

        this.sortBySeverity();
        this.loading = false;
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

    this.scrollToElement('domain-' + catName);
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

  scrollToElement(element) {
    (document.getElementById(element) as HTMLElement).scrollIntoView({behavior: "smooth", block: "start", inline: "nearest"});
  }

}
