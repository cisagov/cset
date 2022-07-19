import { Component, Input, OnInit } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { ReportService } from '../../../services/report.service';

@Component({
  selector: 'app-module-content-standard',
  templateUrl: './module-content-standard.component.html',
  styleUrls: ['./module-content-standard.component.scss']
})
export class ModuleContentStandardComponent implements OnInit {

  @Input()
  set: any;

  constructor(
    private titleSvc: Title,
    public reportSvc: ReportService
  ) { }

  ngOnInit(): void {
    this.titleSvc.setTitle('CSET Module Content Report - ' + this.set.setShortName);
  }

}
