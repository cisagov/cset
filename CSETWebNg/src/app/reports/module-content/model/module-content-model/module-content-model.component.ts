import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-module-content-model',
  templateUrl: './module-content-model.component.html',
  styleUrls: ['./module-content-model.component.scss']
})
export class ModuleContentModelComponent implements OnInit {

  @Input()
  model: any;

  constructor() { }

  ngOnInit(): void {
  }

}
