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
import { ngxCsv } from 'ngx-csv/ngx-csv';

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
  response: any;
  data2=[];

  data1=[];
   options = {
    fieldSeparator: ',',
    quoteStrings: '"',
    decimalseparator: '.',
    showLabels: true,
    showTitle: true,
    title: ['Open Ended Questions'],
    useBom: false,
    noDownload: false,
    headers: ["Category Name","Question Number", "Questions","Parent Answer", "Open Ended Answer"]
  };

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

  loadQuestions() {
    // const magic = this.navSvc.getMagic();
    this.groupings = null;
    this.maturitySvc.getQuestionsList(this.configSvc.installationMode, false).subscribe(
      (response: MaturityQuestionResponse) => {
        // this.modelName = response.modelName;
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

        // console.log(this.onlyOpenQuestionData)
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
  }
  downloadFile2(){

     this.data2.forEach(e=>{
      const title=e.title
      // csvData.push(e.title)
      this.data1.push({title})
      e.myArray.forEach(x => {
        const title=e.title
        const questionNumber=x.displayNumber
        const question=x.questionText
        var OpenAnswer=''
        var ParentAnswer=x.answer
        if(x.freeResponseAnswer){
          OpenAnswer=x.freeResponseAnswer
          ParentAnswer=''
        }

        // this.data1.push(csvData);
        this.data1.push({ title:"", questionNumber,question, ParentAnswer, OpenAnswer});
      });

    })

   new ngxCsv(this.data1, "Open Ended questions report", this.options);
   console.log(this.data1)
  }

}


