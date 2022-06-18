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
  // emptyOpenQuestionData=[];
  onlyOpenQuestionData=[];
  modelName: string = '';
  response: any;
  // showYNQuestions:boolean=false;
  // data1=[];
  data2=[];


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
        this.groupings = response.groupings;
        this.groupings.forEach(element => {
          this.subgroup=element.subGroupings
       this.subgroup.forEach(s=>{
           this.onlyOpenQuestionData.push(s);
          })
        });


         this.onlyOpenQuestionData.forEach(q=>{

            const title=q.title;
            const Subgroup=q.questions.filter(item => !(item.parentQuestionId==null && !item.isParentQuestion));
            const myArray=[]
           Subgroup.forEach(function(item,index) {
             if (Subgroup[index].freeResponseAnswer !=null) {
              myArray.push(Subgroup[index-1]);
              myArray.push(Subgroup[index]) ;
              }
            });
            if(myArray.length>=1){
              this.data2.push({title, myArray})
            }


        })
        console.log(this.data2)
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
  toggleShow(){
    this.openEndedQuestion = ! this.openEndedQuestion;
    console.log(this.openEndedQuestion)
  }
  showExcelExportDialog() {
    const doNotShowLocal = localStorage.getItem('doNotShowExcelExport');
    const doNotShow = doNotShowLocal && doNotShowLocal == 'true' ? true : false;
    if (this.dialog.openDialogs[0] || doNotShow) {
      this.exportToExcel();
      return;
    }
    // this.dialogRef = this.dialog.open(ExcelExportComponent);
    // this.dialogRef
    //   .afterClosed()
    //   .subscribe();
  }

  exportToExcel() {
    window.location.href = this.configSvc.apiUrl + 'ExcelExport?token=' + localStorage.getItem('userToken');
  }

}


