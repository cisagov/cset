import { Component, OnInit, AfterViewChecked, AfterViewInit } from '@angular/core';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';


@Component({
  selector: 'app-acet-compensatingcontrols',
  templateUrl: './acet-compensatingcontrols.component.html',
  styleUrls: ['./acet-compensatingcontrols.component.scss']
})
export class AcetCompensatingcontrolsComponent implements OnInit {
  response: any = null;

  constructor(
    private titleService: Title,

  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("Compensating Controls Report - ASET");


  }

}
