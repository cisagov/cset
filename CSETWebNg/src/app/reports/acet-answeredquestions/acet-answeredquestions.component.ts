import { Component, OnInit, AfterViewChecked, AfterViewInit } from '@angular/core';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';


@Component({
  selector: 'app-acet-answeredquestions',
  templateUrl: './acet-answeredquestions.component.html',
  styleUrls: ['./acet-answeredquestions.component.scss']
})
export class AcetAnsweredquestionsComponent implements OnInit {
  response: any = null;

  constructor(
    private titleService: Title,

  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("Answered Questions Report - ASET");


  }

}
