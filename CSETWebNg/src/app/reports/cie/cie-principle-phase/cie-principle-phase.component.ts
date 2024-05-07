import { Component, ViewChild } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { GroupingDescriptionComponent } from '../../../assessment/questions/grouping-description/grouping-description.component';
import { AssessmentService } from '../../../services/assessment.service';
import { CieService } from '../../../services/cie.service';
import { ConfigService } from '../../../services/config.service';
import { ObservationsService } from '../../../services/observations.service';
import { QuestionsService } from '../../../services/questions.service';
import { ReportService } from '../../../services/report.service';

@Component({
  selector: 'app-cie-principle-phase',
  templateUrl: './cie-principle-phase.component.html',
  styleUrls: ['../../reports.scss', '../../acet-reports.scss', './cie-principle-phase.component.scss']
})
export class CiePrinciplePhaseComponent {

  response: any = {};

  hasComments: any[] = [];
  // showSubcats: Map<String, boolean> = new Map<String, boolean>();
  expandedOptions: Map<String, boolean> = new Map<String, boolean>();

  examLevel: string = '';
  loading: boolean = true;

  @ViewChild('groupingDescription') groupingDescription: GroupingDescriptionComponent;

  constructor(
    public reportSvc: ReportService,
    public assessSvc: AssessmentService,
    public questionsSvc: QuestionsService,
    private titleService: Title,
    public cieSvc: CieService,
    public configSvc: ConfigService,
    public observationSvc: ObservationsService
  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("Export Principle-Phase CIE-CSET - Report");

    this.cieSvc.getCieAllQuestions().subscribe(
      (r: any) => {
        this.response = r;

        // goes through domains
        for (let i = 0; i < this.response?.matAnsweredQuestions[0]?.assessmentFactors?.length; i++) {
          let domain = this.response?.matAnsweredQuestions[0]?.assessmentFactors[i];
          // goes through subcategories
          for (let j = 0; j < domain.components?.length; j++) {
            let subcat = domain?.components[j];
            this.expandedOptions.set(domain?.title + '_' + subcat?.title, false);

            // this.showSubcats.set(domain?.title + '_' + subcat?.title, true);
            // goes through questions
            for (let k = 0; k < subcat?.questions?.length; k++) {
              let question = subcat?.questions[k];

                this.expandedOptions.set(domain?.title + '_' + subcat?.title, false);
                // this.showSubcats.set(domain?.title + '_' + subcat?.title, true);
            }
          }
        }
        this.loading = false;
      },
      error => console.log('Assessment Answered Questions Error: ' + (<Error>error).message)
    );
  }

  /**
   * checks if the quesiton needs to appear
   */
  requiredQuestion(q: any) {
    if (q.answerText == 'U' && q.maturityLevel == 'CORE+') {
      return false;
    }
    return true;
  }

  /**
   * Flips the 'expand' boolean value based off the given 'title' key
   */
  toggleExpansion(title: string) {
    let expand = this.expandedOptions.get(title);
    this.expandedOptions.set(title, !expand);
    return expand;
  }
  /**
   * checks if section should expand by checking the boolean value attached to the 'title'
   */
  shouldExpand(title: string) {
    if (this.expandedOptions.get(title)) {
      return true;
    }
    return false;
  }

  getClasses(q: any, top: boolean) {
    let combinedClass = '';
    if (q.title.length == 10 || q.title.charAt(q.title.length - 1) == '0') {
      combinedClass = 'background-3 ';
    }

    if (top) {
      if (q.freeResponseText == null) {
        combinedClass += 'full-border ';
      }
      else {
        combinedClass += 'top-half-border';
      }
    }
    else{
      combinedClass += 'bottom-half-border';
    }
    return combinedClass;
  }
}
