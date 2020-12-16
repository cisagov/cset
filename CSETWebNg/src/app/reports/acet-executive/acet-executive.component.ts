import { Component, OnInit, AfterViewChecked, AfterViewInit } from '@angular/core';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';


@Component({
  selector: 'app-acet-executive',
  templateUrl: './acet-executive.component.html',
  styleUrls: ['./acet-executive.component.scss']
})
export class AcetExecutiveComponent implements OnInit {
  response: any = null;

  constructor(
    private titleService: Title,

  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("Executive Report - ASET");


  }

}
