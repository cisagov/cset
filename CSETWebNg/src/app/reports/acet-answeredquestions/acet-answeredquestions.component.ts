import { Component, OnInit, AfterViewChecked, AfterViewInit } from '@angular/core';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { ReportService } from '../../services/report.service';
import { ACETService } from '../../services/acet.service';


@Component({
  selector: 'app-acet-answeredquestions',
  templateUrl: './acet-answeredquestions.component.html',
  styleUrls: ['../reports.scss', '../acet-reports.scss']
})
export class AcetAnsweredquestionsComponent implements OnInit {
  response: any = null;

  constructor(
    public reportSvc: ReportService,
    private titleService: Title,
    public acetSvc: ACETService,

  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("Answered Questions Report - ACET");

    this.acetSvc.getAssessmentInfromation().subscribe(
      (r: any) => {
        this.response = r;
      },
      error => console.log('Assessment Infromation Error: ' + (<Error>error).message)
    );


  }

}
