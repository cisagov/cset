import { Component, Input, OnInit } from '@angular/core';
import { Title } from '@angular/platform-browser';

@Component({
  selector: 'app-module-content-standard',
  templateUrl: './module-content-standard.component.html',
  styleUrls: ['./module-content-standard.component.scss']
})
export class ModuleContentStandardComponent implements OnInit {

  @Input()
  set: any;

  constructor(
    private titleSvc: Title
  ) { }

  ngOnInit(): void {
    this.titleSvc.setTitle('CSET Module Content Report - ' + this.set.setShortName);
  }

}
