import { Component, OnInit, Input } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { data } from 'jquery';
import { ConfigService } from '../../../services/config.service';
import { MaturityService } from '../../../services/maturity.service';
import { ReportAnalysisService } from '../../../services/report-analysis.service';
import { ReportService } from '../../../services/report.service';
import { QuestionGrouping, MaturityQuestionResponse, Domain } from '../../../models/questions.model';
import { NavigationService } from '../../../services/navigation.service';
import { QuestionFilterService } from '../../../services/filtering/question-filter.service';
import { MatDialog, MatDialogRef } from '@angular/material/dialog';
import { QuestionFiltersComponent } from '../../../dialogs/question-filters/question-filters.component';
import { MaturityFilteringService } from '../../../services/filtering/maturity-filtering/maturity-filtering.service';

@Component({
  selector: 'app-open-ended-questions',
  templateUrl: './open-ended-questions.component.html',
  styleUrls: ['../../reports.scss', '../../acet-reports.scss', './open-ended-questions.component.scss']
})
export class OpenEndedQuestionsComponent implements OnInit {
  groupings: QuestionGrouping[];
  subgroup: any [];
  openEndedQuestion = false;

  onlyOpenQuestionData=[];
  modelName: string = '';
  response: any;
  // showYNQuestions = false;
  // response: any;
  //
  // @Input() myGrouping: QuestionGrouping;
  // colorSchemeRed = { domain: ['#DC3545'] };
  // xAxisTicks = [0, 25, 50, 75, 100];
  //
  // answerDistribByGoal = [];
  // topRankedGoals = [];

  loaded = false;

  filterDialogRef: MatDialogRef<QuestionFiltersComponent>;
  constructor(
    public analysisSvc: ReportAnalysisService,
    public reportSvc: ReportService,
    public configSvc: ConfigService,
    private titleService: Title,
    public maturitySvc: MaturityService,
    public navSvc: NavigationService,
    public filterSvc: QuestionFilterService,
    public maturityFilteringSvc: MaturityFilteringService,
    private dialog: MatDialog
  ) { }

  ngOnInit() {
    this.loadQuestions();
    this.titleService.setTitle("Validated Architecture Design Review Report - VADR");
  }


  previous = 0;
  shouldDisplay(next) {
    if (next == this.previous) {
      return false;
    }
    else {
      this.previous = next;
      return true;
    }
  }
  loadQuestions() {
    const magic = this.navSvc.getMagic();
    this.groupings = null;
    this.maturitySvc.getQuestionsList(this.configSvc.installationMode, false).subscribe(
      (response: MaturityQuestionResponse) => {
        this.modelName = response.modelName;
        // this.questionsAlias = response.questionsAlias;

        this.groupings = response.groupings;
        this.groupings.forEach(element => {
          this.subgroup=element.subGroupings
          // console.log(this.subgroup)
          this.subgroup.forEach(s=>{
            // this.openEndedQuestion = true;
            this.onlyOpenQuestionData.push(s);
           s.questions.forEach(i => {
              if(i.freeResponseAnswer !=null){
                this.openEndedQuestion=true;
                console.log(this.openEndedQuestion )
              }
            // this.onlyOpenQuestionData.push(i);

           });
          })
        });
        console.log(this.onlyOpenQuestionData)
        this.subgroup.forEach(q=>{
          // console.log(q)
        })
      },
      error => {
        console.log(
          'Error getting questions: ' +
          (<Error>error).name +
          (<Error>error).message
        );
        console.log('Error getting questions: ' + (<Error>error).stack);
      }
    );
  }
}


