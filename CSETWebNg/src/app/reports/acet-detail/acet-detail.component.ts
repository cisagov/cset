import { Component, OnInit, AfterViewChecked, AfterViewInit } from '@angular/core';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';


@Component({
  selector: 'app-acet-detail',
  templateUrl: './acet-detail.component.html',
  styleUrls: ['./acet-detail.component.scss']
})
export class AcetDetailComponent implements OnInit {
  response: any = null;

  constructor(
    private titleService: Title,

  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("Detailed Report - ASET");

  }

}
