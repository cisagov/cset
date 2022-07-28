import { Component, Input, OnInit } from '@angular/core';
import { Title } from '@angular/platform-browser';


/**
 * The page-level wrapper for a Module Content Report containing a (Maturity) Model.
 */
@Component({
  selector: 'app-module-content-model',
  templateUrl: './module-content-model.component.html',
  styleUrls: ['./module-content-model.component.scss']
})
export class ModuleContentModelComponent implements OnInit {

  @Input()
  model: any;

  constructor(
    private titleSvc: Title
  ) { }

  ngOnInit(): void {
    this.titleSvc.setTitle('CSET Module Content Report - ' + this.model.modelName);
  }

}
